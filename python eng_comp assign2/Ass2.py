from math import *
from collections import defaultdict
from collections import namedtuple

Speaker = namedtuple('Speaker', ['x','y','lvl'])
Point = namedtuple('Point', ['x','y'])
Vertice = namedtuple('Vertice', ['x','y'])

meas_dist = 1
low_w, high_w, int_w = 4, 312, 4
low_h, high_h, int_h, int_h2 = 4, 312, 4, 8

# returns euclidean distance for 2 points
def dist(p1,p2):
    return(sqrt(((p1[0] - p2[0])**2 + (p1[1] - p2[1])**2)))
    
# returns simplied sound lvl calculation for a speaker at a certain
# location as measured at a certain point location
def sound_lvl(raw_data, ref_point):
    lvl_lst = []
    
    for namedtuple in raw_data:
        denom = dist((float(namedtuple.x), float(namedtuple.y)), ref_point)
        if denom == 0:
            continue
        L2 = float(namedtuple.lvl) + 20*log10(meas_dist/denom)
        if L2 < 0:
            L2 = 0
        
        lvl_lst.append(L2)
    
    return(lvl_lst)

# sums up aggregate sound due to speakers
def sound_sum(lst):
    sum = 0
    
    for spkr_lvl in lst:
        sum += 10**(spkr_lvl/10)
        
    return(10*log10(sum))    
        
def main(args):
    s_lst, p_lst, v_lst = [], [], []
    
    # for text files you don't need to call an iterator function
    # like csv.reader() - f is the iterator
    
    with open('input.txt','r') as f:
        for row in f:
            row_lst = row.split()
            if row_lst[0] == 'S':
                s_temp = Speaker(row_lst[1], row_lst[2], row_lst[3])
                s_lst.append(s_temp)
            elif row_lst[0] == 'P':
                p_temp = Point(row_lst[1], row_lst[2])
                p_lst.append(p_temp)
            else:
                v_temp = Vertice(row_lst[1], row_lst[2])
                v_lst.append(v_temp)
    
    Stage1(s_lst[:4], (0,0))
    #Stage2(s_lst, p_lst)
    Stage3(s_lst[:4], low_w, high_w, int_w, low_h, high_h, int_h)
    Stage4(s_lst[:4], low_w, high_w, int_w, low_h, high_h, int_h2)
    
    return 0
    
def Stage1(lst, ref_point):
    lvls = sound_lvl(lst, ref_point)
    sum_val = sound_sum(lvls) 
    
    print('Stage 1\n==========')
    print('Number of loudspeakers: {n1:02}'.format(n1 = len(lst)))
    print('Sound level at ({n1:05.1f},{n2:05.1f}): {n3:.2f} dB'.format(n1 = ref_point[0],
    n2 = ref_point[1], n3 = sum_val))
    return 0

def Stage2(s_lst, p_lst): 
    print('\nStage 2\n==========')
    
    for point in p_lst:
        lvls = sound_lvl(s_lst, (float(point.x), float(point.y)))
        sum_val = sound_sum(lvls)
        print('Sound level at ({n1:05.1f},{n2:05.1f}): {n3:.2f} dB'.format(n1 = float(point.x),
        n2 = float(point.y), n3 = sum_val))
    return 0

def Stage3(s_lst, low_w, high_w, int_w, low_h, high_h, int_h):
    total = 0; less = 0
    width = range(low_w, high_w, int_w)
    height = range(low_h, high_h, int_h)
    
    for x in width:
        for y in height:
            total += 1
            lvls = sound_lvl(s_lst, (x,y))
            sum_val= sound_sum(lvls)
            if sum_val <= 55:
                less += 1
    
    print('\nStage 3\n==========')
    print('{} points sampled'.format(total))
    print('{} points ({:.2f}%) have sound level <= 55 dB'.format(less, (less/total)*100))
    return 0
   
   # Prints out a map of aggregated sound_lvl at points on a grid   
def Stage4(s_lst, low_w, high_w, int_w, low_h, high_h, int_h2):
    centre_w = 2; # centre points
    width = range(low_w-centre_w, high_w, int_w)
    height = range(308, 0, -int_h2);
    #print(list(width))
    #print(list(height))
    
    for y in height:
        for x in width:
            lvls = sound_lvl(s_lst, (x,y))
            sum_val = sound_sum(lvls)
            
            if sum_val >= 100:
                print('+', end = '')
            elif (sum_val < 100 and sum_val >= 90):
                print(' ', end = '')
            elif (sum_val < 90 and sum_val >= 80):
                print('8', end = '')
            elif (sum_val < 80 and sum_val >= 70):
                print(' ', end = '')
            elif (sum_val < 70 and sum_val >= 60):
                print('6', end = '')
            elif (sum_val < 60 and sum_val > 55):
                print(' ', end = '')
            else:
                print('-', end = '')
            
            if (x == 310):
                print('\n', end='')
                
                
    
    return 0 

if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))
