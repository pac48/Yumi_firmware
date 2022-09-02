MODULE movetest
    !***********************************************************
    !
    ! Module:  Unnamed
    !
    ! Description:
    !   <Insert description here>
    !
    ! Author: yumi
    !
    ! Version: 1.0
    !
    !***********************************************************
    
    
    !***********************************************************
    !
    ! Procedure main
    !
    !   This is the entry point of your program
    !
    !***********************************************************
    PROC main()
        !Add your code here
        VAR jointtarget goal:= [ [ 0, 0, 0, 0, 0, 0], [ 0, 9E9,9E9, 9E9, 9E9, 9E9] ];
        VAR jointtarget curjoints;
        curJoints := CJointT(\TaskName:="T_ROB_R");
        goal:=curJoints;
        goal.robax.rax_3:=0;
        MoveAbsJ goal, v10 \T:=2,z200,tool0;
        WaitTime 2;
        MoveAbsJ curJoints, v10 \T:=2,z200,tool0;
        WaitTime 3;
        
        g_Init;
        g_Calibrate;
        WaitTime 3;
        g_MoveTo 15;
        WaitTime 1;
        g_MoveTo 0;
        WaitTime 1;


    ENDPROC
ENDMODULE