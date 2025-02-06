 #include "stdio.h"

 int main() {
    // printf("Hello World!\n");
     asm volatile(".word 0x0000006b");
     return 0;
 }
