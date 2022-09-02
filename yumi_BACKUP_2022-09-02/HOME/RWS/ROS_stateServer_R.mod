MODULE ROS_stateServer_R
    LOCAL CONST num server_port:=11002;
    LOCAL CONST num update_rate:=0.01;
    LOCAL VAR socketdev server_socket;
    LOCAL VAR socketdev client_socket;
    LOCAL VAR ROS_msgs msgs;

    PROC main()
        TPWrite "StateServer_R: Waiting for connection.";
        ROS_init_socket server_socket,server_port;
        ROS_wait_for_client server_socket,client_socket;

        WHILE (TRUE) DO
            send_data;
            WaitTime update_rate;
        ENDWHILE

    ERROR (ERR_SOCK_TIMEOUT,ERR_SOCK_CLOSED)
        IF (ERRNO=ERR_SOCK_TIMEOUT) OR (ERRNO=ERR_SOCK_CLOSED) THEN
            SkipWarn;
            ! TBD: include this error data in the message logged below?
            ErrWrite\W,"ROS StateServer_R disconnect","Connection lost.  Waiting for new connection.";
            ExitCycle;
            ! restart program
        ELSE
            TRYNEXT;
        ENDIF
    UNDO
    ENDPROC

    LOCAL PROC send_data()
        msgs.joint_position_msg.joints:=CJointT(\TaskName:="T_ROB_R");
        msgs.joint_torque_msg.joints.robax.rax_1:= GetMotorTorque(\MecUnit:=ROB_R,1);
        msgs.joint_torque_msg.joints.robax.rax_2:= GetMotorTorque(\MecUnit:=ROB_R,2);
        msgs.joint_torque_msg.joints.extax.eax_a:= GetMotorTorque(\MecUnit:=ROB_R,3);
        msgs.joint_torque_msg.joints.robax.rax_3:= GetMotorTorque(\MecUnit:=ROB_R,4);
        msgs.joint_torque_msg.joints.robax.rax_4:= GetMotorTorque(\MecUnit:=ROB_R,5);
        msgs.joint_torque_msg.joints.robax.rax_5:= GetMotorTorque(\MecUnit:=ROB_R,6);
        msgs.joint_torque_msg.joints.robax.rax_6:= GetMotorTorque(\MecUnit:=ROB_R_7,1);
        msgs.gripper_position_msg.position:=g_GetPos();
        ROS_send_msg_all_data client_socket, msgs;   !(VAR socketdev client_socket, ROS_msg_joint_data jointPositions,ROS_msg_joint_data jointTorques, ROS_msg_gripper_target gripperPosition, ROS_msg_gripper_target gripperForce)

    ERROR
        RAISE ;
        ! raise errors to calling code
    ENDPROC


ENDMODULE
