import csv
from math import *
from collections import defaultdict

p2 = (144.963123, -37.810592)

### Python implementation of an old univeristy assignment completed in
### C.  Essentially reads in victorian car crash data longitude and 
### latitude, time, and date. 
### Calculates distances to some points, with graphical representation.
### Run to find out the output; largely self explanatory.

# if you need to reduce the raw dataset to what is needed for spec
def subsetdata():
    with open('Crashes_Last_Five_Years.csv', newline = '') as csvfile:
        reader = csv.reader(csvfile, delimiter = ',')
        with open('specdata.csv', 'w', newline = '') as writefile:
            writefile_reader = csv.writer(writefile, delimiter = ',', 
            quotechar = '"', quoting = csv.QUOTE_MINIMAL)
            for row in reader:
                writefile_reader.writerow([row[0], row[18], row[19],
                row[4], row[5], row[8]])   
    return 0

# converts a latitude of longitude value to radians
def toRadian(x):
    return(x*(pi/180))

# for stage 2 this builds the data visualization as a list to print
def distance_viz(x):
    count = 0;
    stringy = "|"
    
    while (x > 0):
        count += 1
        if (count % 10 == 0):
            stringy = stringy + '+'
        else:
            stringy = stringy + '-'
        x = x-1
    
    return(stringy)

# haversine formula returns the distance between two points
# p2 is a global point
def haversine(p1):    
    chord_length = sin((toRadian(p2[1]-p1[1]))/2)**2  
    + cos(toRadian(p1[1])) * cos(toRadian(p2[1]))  
    + sin((toRadian(p2[0]-p1[0]))/2)**2
    
    angle_distance = 2*atan2(sqrt(chord_length), sqrt(1-chord_length))
    return(6371*angle_distance)

def main(args):
#    subsetdata()
    ID, Long, Lat, Date, Time, Day = [], [], [], [], [], []
    
    with open('specdata.csv', 'r', newline ='') as csvfile:
        reader = csv.reader(csvfile, delimiter = ',')
        next(reader) # skip the header! Remember reader is an 
        #iterator for the lines in the csvfile             
        #list of strings in the row
        for row in reader:
            ID.append(row[0]); Long.append(row[1]); Lat.append(row[2]);
            Date.append(row[3]); Time.append(row[4]); Day.append(row[5]);     
    
    Stage1(ID[0], Long[0], Lat[0], Time[0], Date[0])
    Stage2(ID[:10], Long[:10], Lat[:10])    
    #Stage3_listway(Day[:50])
    #Stage3_dictway(Day[:50])
    Stage3_ezlist(Day[:50])
    Stage4(ID[:10], Long[:10], Lat[:10])
    return 0

# run the program to find out what the stages do!
def Stage1(ID, Long, Lat, Time, Date):
    print("Stage 1\n==========\nAccident: #{n1}\nLocation: <{n2},{n3}>\n"
    "Date: {n4}\nTime: {n5}\nDistance to Reference: {n6}".format(n1 = ID,
    n2 = Long, n3 = Lat, n4 = Date, n5 = Time, 
    n6 = haversine((float(Long),float(Lat)))))
    return 0
    
def Stage2(ID, Long, Lat):
    print("\nStage 2\n==========\n")
    
    # look at n2 string formatting carefully - useful
    for (idy,longy,laty) in zip(ID,Long,Lat):  
        print("Accident: #{n1}, distance to reference: {n2:05.2f} {n3}".format(n1 = idy,
        n2 = haversine((float(longy),float(laty))), 
        n3 = distance_viz(haversine((float(longy),float(laty))))))
    return 0
    
    # This is manually sorting, and finding earliest day.
def Stage3_listway(Day_vec):
    lst1 = ["Monday", "Tuesday", "Wednesday", "Thursday",
    "Friday", "Saturday", "Sunday"]
    lst2 = [0,0,0,0,0,0,0]
    
    for Day in Day_vec:
        count = 0
        for Day_test in lst1:
            if Day_test == Day:
                lst2[count] += 1
            else:
                count += 1
    
    pos = 0; max_accid = 0; count2 = 0;
    
    for num in lst2:
        
        if num > max_accid:
            max_accid = num
            pos = count2
                
        count2 += 1
                    
    print("Stage 3\n==========")
    print("Number of accidents: {}".format(len(Day_vec)))
    print("Day of week with the most accidents: {} ({} accident(s))".format(lst1[pos], max_accid))
    
    return 0    
    # using inbuild list sorting function.  Definitely the easiest way.
def Stage3_ezlist(Day_vec):
    dicky2 = {'Monday': 0, 'Tuesday': 1, 'Wednesday': 2, 'Thursday': 3,
    'Friday': 4, 'Saturday': 5, 'Sunday': 6}
    lst2 = [(Day_vec.count(day), dicky2[day]) for day in dicky2.keys()]
    sorted(lst2)
    
    max_accid = lst2[0][0]; cur_day = lst2[0][1]; 
    ret_day = list(dicky2.keys())[list(dicky2.values()).index(cur_day)]
    print("\nStage 3\n==========")
    print("Number of accidents: {}".format(len(Day_vec)))
    print("Day of week with the most accidents: {} ({} accident(s))"
    .format(ret_day, max_accid))
    
    return 0
    # Forcing myself to use dictionaries.
def Stage3_dictway(Day_vec):
    dicky = defaultdict(int);
    dicky2 = {'Monday': 0, 'Tuesday': 1, 'Wednesday': 2, 'Thursday': 3,
    'Friday': 4, 'Saturday': 5, 'Sunday': 6}
    
    for day in Day_vec:
        dicky[day] += 1
    
    # note we return a list here, so we can sort on a list.
    # as sorting on a dictionary has no basis - this sort of dict has 
    # no order.
    lst1 = [(value,key) for (key,value) in dicky.items()]
    sorted(lst1)
    
    lst2 = []; max_accid = 0;
    for (value,key) in lst1:
        if (key in dicky2.keys()):
            lst2.append((value, dicky2[key]))
    
    max_accid = lst2[0][0]; cur_day = lst2[0][1]; 
    
    for (value,day) in lst2:
        if ((value >= max_accid) and (day < cur_day)):
            max_accid = value
            cur_day = day
    
    # this is clever
    ret_day = list(dicky2.keys())[list(dicky2.values()).index(cur_day)]
    
    print("Stage 3\n==========")
    print("Number of accidents: {}".format(len(Day_vec)))
    print("Day of week with the most accidents: {} ({} accident(s))".format(ret_day, max_accid))
    
    return 0

def Stage4(ID, Long, Lat):
    
    lst1 = [(idy, haversine((float(longy),float(laty))))
    for (idy,longy,laty)
    in zip(ID,Long,Lat)]
    
    lst1.sort(key=takeSecond)
    
    print("\nStage 4\n==========")
    for (idy, dist) in lst1:
        print("This is ID: {} with distance: {:.2f}".format(idy,dist))
    
    return 0

def takeSecond(elem):
    return elem[1]

if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))
