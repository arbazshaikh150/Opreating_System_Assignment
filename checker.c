#include <stdio.h>
#include <unistd.h> /// For using the sleep function
int main(){
   ///// We have to allocate the memory for checking the stats
   int n;
   printf("The address of the variable : %p\n", &n);
   printf("Enter the number of elements in the array : ");
   scanf("%d", &n);
   int a[n];
   for(int i = 0 ; i < n ; i++){
       a[i] = 1;
   }
   printf("Waiting for 10 seconds...\n");
   for(int i = 0 ; i < 10 ; i++){
       sleep(1);
      }
      
   printf("Enter the number of elements in the array : ");
   scanf("%d", &n);
   int b[n];
   for(int i = 0 ; i < n ; i++){
       b[i] = 1;
   }
   printf("Waiting for 10 seconds...\n");
   for(int i = 0 ; i < 10 ; i++){
       sleep(1);
      }
      return 0;
}


