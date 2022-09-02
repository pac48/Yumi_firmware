MODULE ROS_EGM_R
    ! Home position.
    VAR jointtarget home; ! := [[0, 0, 0, 0, 30, 0], [9E9, 9E9, 9E9, 9E9, 9E9, 9E9]];
    ! Identifier for the EGM correction.
    LOCAL VAR egmident egm_id;
    
    ! Limits for convergance.
    LOCAL VAR egm_minmax egm_condition := [-0.1, 0.1]; 
            
    PROC main()
        home.robax.rax_1:=41;
        home.robax.rax_2:=-121;
        home.extax.eax_a:=-83;
        home.robax.rax_3:=-9;
        home.robax.rax_4:=23;
        home.robax.rax_5:=60;
        home.robax.rax_6:=23;
        MoveAbsJ home, v200, fine, tool0;
        WHILE TRUE DO
            ! Register an EGM id.
            EGMGetId egm_id;
            
            ! Setup the EGM communication.
            EGMSetupUC ROB_R, egm_id, "lowBand", "ROB_R", \Joint;
            
            ! Prepare for an EGM communication session.
            EGMActJoint egm_id \J1:=egm_condition \J2:=egm_condition \J3:=egm_condition \J4:=egm_condition \J5:=egm_condition \J6:=egm_condition \J7:= egm_condition \MaxSpeedDeviation:=1000000; ! \LpFilter:=20  \MaxSpeedDeviation:=10;
                        
            ! Start the EGM communication session.
            EGMRunJoint egm_id, EGM_STOP_RAMP_DOWN, \J1 \J2 \J3 \J4 \J5 \J6 \J7 \CondTime:=5 \RampOutTime:=1,\PosCorrGain:=0;
            
            ! Release the EGM id.
            EGMReset egm_id;
            
            WaitTime 1;
        ENDWHILE
        
    ERROR
        IF ERRNO = ERR_UDPUC_COMM THEN
            TPWrite "Communication timedout";
            TRYNEXT;
        ENDIF
    ENDPROC
ENDMODULE