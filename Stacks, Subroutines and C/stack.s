//The Stack
//Narry Zendehrooh 260700556
//Imane Chafi 260847716
  
            .text
            .global _start

_start:
            MOV R0, #5     // move an identifiable value into R0
            MOV R1, #-100     // move an identifiable value into R1
            MOV R2, #22     // move an identifiable value into R2

PUSH_ELEMENT:
            STMDB SP!, {R0} // push R0 onto the stack (STORE MULTIPLE AND DECREASE BEFORE)
            STMDB SP!, {R1}// push R1 onto the stack  (STORE MULTIPLE AND DECREASE BEFORE)
            STMDB SP!, {R2}// push R2 onto the stack  (STORE MULTIPLE AND DECREASE BEFORE)

POP_ELEMENT:
            LDMIA SP!, {R0 - R2} // POP {R0 - R2} (LOAD MULTIPLE AND INCREASE AFTER)

END:
            B END // infinite loop!
