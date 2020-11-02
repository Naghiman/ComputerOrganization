//C pure code to iterate through an array and find the maximum
#include <stdio.h>
//Imane Chafi 260847716
int main(){
	int a[5] = {21,33,12,19,15};
	int max_val;
	//TO DO Fill this in
			max_val = a[0];
			int i;
			for (i =0; i<5; i++){
				if(max_val < a[i]){
					max_val = a[i];
				}
			}
	return max_val;
	}
