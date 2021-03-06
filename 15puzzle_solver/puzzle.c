/* Written by Matthew Feldman - using IDA A* algorithm, this code solves
the 15puzzle for different configurations.  Specifically - Everything not 
labelled BASE written by MF.

Explanation - Iterative-deepening-A* works as follows: at each iteration, 
perform a depth-first search, cutting off a branch when its total cost
f(n)=g(n)+h(n) exceeds a given threshold. g = cost to get there. 
h = estimated heuristic cost to get from new current point to solution.
This threshold starts at the estimate of the cost at the initial state, and 
increases for each iteration of the algorithm. At each iteration, the threshold
used for the next iteration is the minimum cost of all values that exceeded 
the current threshold.
*/

#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <sys/types.h>
#include <sys/resource.h>
#include <sys/time.h>

typedef struct node{
	int state[16];
	int g;
	int f;
} node;

node* IDA(node* n, int threshold, int* newThreshold, int last_move);
int min(int a, int b);

int blank_pos;
node initial_node;
unsigned long generated;
unsigned long expanded;

int ap_opLeft[]  = { 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1 };
int ap_opRight[]  = { 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0 };
int ap_opUp[]  = { 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
int ap_opDown[]  = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0 };
int *ap_ops[] = { ap_opLeft, ap_opRight, ap_opUp, ap_opDown };

/* return 1 if op is applicable in state, otherwise return 0 */
int applicable(int op) {
       	return( ap_ops[op][blank_pos] );
}

void print_state(int* s) {
	int i;
	for( i = 0; i < 16; i++ )
		printf( "%2d%c", s[i], ((i+1) % 4 == 0 ? '\n' : ' ') );
}
      
void printf_comma (long unsigned int n) {
    if (n < 0) {
        printf ("-");
        printf_comma (-n);
        return;
    }
    if (n < 1000) {
        printf ("%lu", n);
        return;
    }
    printf_comma (n/1000);
    printf (",%03lu", n%1000);
}

void apply(node* n, int op ) {
	int t;

	//find tile that has to be moved given the op and blank_pos
	t = blank_pos + (op == 0 ? -1 : (op == 1 ? 1 : (op == 2 ? -4 : 4)));
	
	n->state[blank_pos] = n->state[t];
	n->state[t] = 0;
	
	//update blank pos
	blank_pos = t;
	return;
}

#define LEFT 0
#define RIGHT 1
#define UP 2
#define DOWN 3
#define NEG -1

int manhattan(int* state) {
	int sum = 0; int manhattan_distance = 0; int i = 0;
	int x_start = 0; int y_start = 0;
	int x_dest = 0; int y_dest = 0;
	
	for (i = 0; i < 16; i++) {
		
		x_dest = (state[i] / 4);
		y_dest = (state[i] % 4);
		
		if (i != 0) {
		y_start += 1;
		}
		
		if (i%4 == 0 && i != 0) {
			x_start += 1;
			y_start = 0;
		}
		
	manhattan_distance = abs((x_start-x_dest)) + abs((y_start-y_dest));
	
	// don't contribute 0 to the manhattan distance
	if (state[i] == 0) {
		manhattan_distance = 0;
		}
	sum += manhattan_distance;
	}
	return(sum);
}

int IDA_control_loop() {
	node* r = NULL;
	int threshold = 0; 
	int initial_B_dash = INT_MAX;
	
	generated = 0;
	expanded = 0;

	initial_node.f = threshold = manhattan(initial_node.state);
	printf( "\nInitial Estimate = %d\nThreshold = %d ", threshold, threshold);
	
	while (r == NULL) {
		initial_B_dash = INT_MAX;
		
		r = IDA(&initial_node, threshold, &initial_B_dash, NEG);
		
		/* if we recurse entirely through one branch, and a solution hasn't 
		been found we are starting again but with a new threshold, that is
		the minimum of all the ones that we just discovered e.g. we went 
		through a branch and discovered new threshold of 9, 14, 17 - well
		we would then start to recurse again with a threshold of 9 - because 
		then we can recurse down that branch again which had 9 */
		
		if (r == NULL) {
			threshold = initial_B_dash; // this is the highest threshold now.
			printf("%d ", threshold);
		}
	}
	return r->g;  
}


node* IDA(node* n, int threshold, int* newThreshold, int last_move) {
	int i = 0; int non_allowed = NEG;
	node* r = NULL; 
	expanded = expanded+1;
	
	// check what last move is - set non_allowed to be the 
	// opposite of that move
	
	if (last_move == 0) {
		non_allowed = 1;
	} 
	else if (last_move == 1) {
		non_allowed = 0;
	}
	else if (last_move == 2) {
		non_allowed = 3;
	} 
	else if (last_move == 3) {
		non_allowed = 2;
	}
	
	for (i = 0; i < 4; i++) {
		if ((applicable(i) == 1) && (i != non_allowed)) {
			generated = generated+1;
			apply(n, i);						// apply i
			n->g = n->g + 1;					// cost of getting this state 
			n->f = n->g + manhattan(n->state);	// cost+heuristic(new state)
			
			
			/* when going down the branch just continually updating the 
			new threshold to be the minimum found */
			if (n->f > threshold) {
				*newThreshold = min(n->f, *newThreshold);
			}
				
			/* if the new state has a cost + heuristic <= to the current
			threshold it will continue to recurse down that solution branch/path 
			*/
			
			else {
				if (manhattan(n->state) == 0) {
					return n; //found solution - return up through stack
					}
					
				last_move = i;
				r = IDA(n, threshold, newThreshold, last_move);				
						
				if (r != NULL) {
					return r;
					}
				}
				
				
				// revert back to previous state
				if (i == LEFT) {
					apply(n, RIGHT);
				}
				else if (i == RIGHT) {
					apply(n, LEFT);
				}
				else if (i == UP) {
					apply(n, DOWN);
				} 
				else if (i == DOWN) {
					apply(n, UP);
				}
				
				n->g = n->g - 1;
				n->f = n->g + manhattan(n->state);
		}
	} //end for loop
return NULL;
}

// min function
int min(int a, int b) {
	if (a <= b) {
		return a;
	} else {
		return b;
	}
}

// BASE CODE
static inline float compute_current_time()
{
	struct rusage r_usage;
	
	getrusage( RUSAGE_SELF, &r_usage );	
	float diff_time = (float) r_usage.ru_utime.tv_sec;
	diff_time += (float) r_usage.ru_stime.tv_sec;
	diff_time += (float) r_usage.ru_utime.tv_usec / (float)1000000;
	diff_time += (float) r_usage.ru_stime.tv_usec / (float)1000000;
	return diff_time;
}

int main( int argc, char **argv )
{
	int i, solution_length;

	/* check we have a initial state as parameter */
	if( argc != 2 )
	{
		fprintf( stderr, "usage: %s \"<initial-state-file>\"\n", argv[0] );
		return( -1 );
	}

	/* read initial state */
	FILE* initFile = fopen( argv[1], "r" );
	char buffer[256];

	if( fgets(buffer, sizeof(buffer), initFile) != NULL ){
		char* tile = strtok( buffer, " " );
		for( i = 0; tile != NULL; ++i )
			{
				initial_node.state[i] = atoi( tile );
				blank_pos = (initial_node.state[i] == 0 ? i : blank_pos);
				tile = strtok( NULL, " " );
			}		
	}
	else{
		fprintf( stderr, "Filename empty\"\n" );
		return( -2 );

	}
       
	if( i != 16 )
	{
		fprintf( stderr, "invalid initial state\n" );
		return( -1 );
	}

	/* initialize the initial node */
	initial_node.g=0;
	initial_node.f=0;

	print_state( initial_node.state );

	/* solve */
	float t0 = compute_current_time();
	
	solution_length = IDA_control_loop();				

	float tf = compute_current_time();
	
	/* report results */
	printf( "\nSolution = %d\n", solution_length);
	printf( "Generated = ");
	printf_comma(generated);		
	printf("\nExpanded = ");
	printf_comma(expanded);		
	printf( "\nTime (seconds) = %.2f\nExpanded/Second = ", tf-t0 );
	printf_comma((unsigned long int) expanded/(tf+0.00000001-t0));
	printf("\n\n");

	/* aggregate all executions in a file named report.dat, for marking purposes */
	FILE* report = fopen( "report.dat", "a" );

	fprintf( report, "%s", argv[1] );
	fprintf( report, "\n\tSoulution = %d, Generated = %lu, Expanded = %lu", solution_length, generated, expanded);
	fprintf( report, ", Time = %f, Expanded/Second = %f\n\n", tf-t0, (float)expanded/(tf-t0));
	fclose(report);
	
	return( 0 );
}