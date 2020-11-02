
////////////Code edited from pure c program to call max2 from subroutine/////////
extern int MAX_2(int x, int y);

//Imane Chafi 260847716

int main(){ //Normal forloop for finding the max in an array!
    int a[5] = {1, 20, 34, 4, 55};
    int max_val;
	max_val = a[0];
    int i;
    for (i=1; i<5; i++){
        max_val = MAX_2(max_val, a[i]);
    }
    return max_val;
}
