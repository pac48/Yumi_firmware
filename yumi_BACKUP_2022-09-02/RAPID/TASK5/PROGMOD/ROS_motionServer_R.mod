MODULE ROS_motionServer_R
    VAR num gripperPosition;   
    VAR jointtarget jointCommand;
    VAR num hold_force;
    LOCAL CONST num server_port:=11000;
    LOCAL CONST num update_rate:=0.01;
    ! broadcast rate (sec)
    LOCAL VAR socketdev server_socket;
    LOCAL VAR socketdev client_socket;


    PROC main()
        g_JogOut;
        g_JogIn;
        g_Calibrate;
        g_Init \maxSpd:=20, \holdForce:=20;
        g_MoveTo(10);
        hold_force := 20;
        TPWrite "MotionServer_R: Waiting for connection.";
        ROS_init_socket server_socket,server_port;
        ROS_wait_for_client server_socket,client_socket;

        WHILE (TRUE) DO
        get_data;
        WaitTime update_rate;
        ENDWHILE

        ERROR (ERR_SOCK_TIMEOUT,ERR_SOCK_CLOSED)
        IF (ERRNO=ERR_SOCK_TIMEOUT) OR (ERRNO=ERR_SOCK_CLOSED) THEN
            SkipWarn;
            ! TBD: include this error data in the message logged below?
            ErrWrite\W,"ROS MotionServer_R disconnect","Connection lost.  Waiting for new connection.";
            ExitCycle;
            ! restart program
        ELSE
            TRYNEXT;
        ENDIF
    UNDO
    ENDPROC
    
    LOCAL PROC get_data()
        ROS_receive_msg_all_data client_socket;
        IF (NOT msgs.gripper_position_msg.header.msg_type = ROS_MSG_TYPE_NULL) THEN
            IF (NOT msgs.gripper_force_msg.header.msg_type = ROS_MSG_TYPE_NULL) THEN
                hold_force := msgs.gripper_force_msg.force;
            ELSE
                hold_force := 20;
            ENDIF
            g_SetForce hold_force;
            IF msgs.gripper_position_msg.position < g_GetPos() THEN
                g_GripIn \NoWait;
             ELSE
                g_GripOut \NoWait;
            ENDIF
            !IF Abs(msgs.gripper_position_msg.position - g_GetPos()) > 1 THEN
            !    g_GripIn \holdForce:=hold_force \NoWait;
            !ENDIF
            !ELSE
            !   g_GripOut \holdForce:=hold_force \targetPos:=msgs.gripper_position_msg.position \NoWait;
            !ENDIF
        ENDIF
       !TPWrite"gripper_position_R type" \Num:=msgs.gripper_position_msg.header.msg_type;
        TPWrite"gripper_position_R position" \Num:= msgs.gripper_position_msg.position;
       !TPWrite"gripper_force_R type" \Num:=msgs.gripper_force_msg.header.msg_type;
        TPWrite"gripper_force_R force" \Num:= msgs.gripper_force_msg.force;
    ERROR
        RAISE ;
        ! raise errors to calling code
    ENDPROC
    
ENDMODULE