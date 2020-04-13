Written by MF - using IDA A* algorithm, this code solves
the 15puzzle for different configurations.  Specifically - Everything not 
labelled BASE written by MF.

For an explanation of what the 15puzzle is see: https://en.wikipedia.org/wiki/15_puzzle

The code does this via a depth first search tree method (IDA A*):

Iterative-deepening-A * works as follows: at each iteration, 
perform a depth-first search, cutting off a branch when its total cost
f(n)=g(n)+h(n) exceeds a given threshold. g = cost to get there. 
h = estimated heuristic cost to get from new current point to solution.
This threshold starts at the estimate of the cost at the initial state, and 
increases for each iteration of the algorithm. At each iteration, the threshold
used for the next iteration is the minimum cost of all values that exceeded 
the current threshold.

How to use:
Download the folder and use the make command in your cmd line.  This will make the 
executable program.  To then run just input '15puzzle x.puzzle' - where x.puzzle is
one of the text files in the downloadable folder.
