  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   quicksort
  .global   partition
  .global   swap

@ quicksort subroutine
@ Sort an array of words using Hoare's quicksort algorithm
@ https://en.wikipedia.org/wiki/Quicksort 
@
@ Parameters:
@   R0: Array start address
@   R1: lo index of portion of array to sort
@   R2: hi index of portion of array to sort
@
@ Return:
@   none
quicksort:
  PUSH    {R4-R7,LR}                      @ add any registers R4...R12 that you use

  @ *** PSEUDOCODE ***
  @ if (lo < hi) 
  @ { // !!! You must use signed comparison (e.g. BGE) here !!!
  @   p = partition(array, lo, hi);
  @   quicksort(array, lo, p - 1);
  @   quicksort(array, p + 1, hi);
  @ }

  
  CMP     R1, R2
  BGE     endMain
  BL      partition
  MOV     R5, R3
  SUB     R5, R5, #1
  MOV     R2, R5
  BL      quicksort
  ADD     R3, R3, #1
  MOV     R1, R3
  LDR     R2, =9
  BL      quicksort
endMain:





  @
  @ your implementation goes here
  @

  POP     {R4-R7,PC}                      @ add any registers R4...R12 that you use


@ partition subroutine
@ Partition an array of words into two parts such that all elements before some
@   element in the array that is chosen as a 'pivot' are less than the pivot
@   and all elements after the pivot are greater than the pivot.
@
@ Based on Lomuto's partition scheme (https://en.wikipedia.org/wiki/Quicksort)
@
@ Parameters:
@   R0: array start address
@   R1: lo index of partition to sort
@   R2: hi index of partition to sort
@
@ Return:
@   R0: pivot - the index of the chosen pivot value
partition:
  PUSH    {R4-R10,LR}                      @ add any registers R4...R12 that you use

  @ *** PSEUDOCODE ***
  @ pivot = array[hi];
  @ i = lo;
  @ for (j = lo; j <= hi; j++) 
  @ {
  @   if (array[j] < pivot) 
  @   {
  @     swap (array, i, j);
  @     i = i + 1;
  @   }
  @ }
  @ swap(array, i, hi);
  @ return i;

  MOV     R8, R2
  MOV     R9, R1
  MOV     R10, R6
  LDR     R4, [R0, R2, LSL #2]   
  MOV     R5, R1                 
  MOV     R6, R1                 
For:
  CMP     R6, R2
  BGT     Next
  LDR     R7, [R0, R6, LSL #2]   
  CMP     R7, R4
  BGE     Increment
  MOV     R1, R5
  MOV     R2, R6
  BL      swap
  ADD     R5, R5, #1
Increment:
  ADD     R6, R6, #1
  MOV     R2, R8
  B       For
Next:
  MOV     R1, R5
  MOV     R2, R8
  BL      swap
  MOV     R3, R5
  MOV     R1, R9

  POP     {R4-R10,PC}                      @ add any registers R4...R12 that you use



@ swap subroutine
@ Swap the elements at two specified indices in an array of words.
@
@ Parameters:
@   R0: array - start address of an array of words
@   R1: a - index of first element to be swapped
@   R2: b - index of second element to be swapped
@
@ Return:
@   none
swap:
  PUSH    {R4-R5,LR}
  LDR     R4, [R0, R1, LSL #2]   @ elem1 = word[array + (a * 4)]
  LDR     R5, [R0, R2, LSL #2]   @ elem2 = word[array + (b * 4)]
  STR     R5, [R0, R1, LSL #2]   @ word[array + (a * 4)] = elem2
  STR     R4, [R0, R2, LSL #2]   @ word[array + (b * 4)] = elem1
  


  

  POP     {R4-R5,PC}


.end