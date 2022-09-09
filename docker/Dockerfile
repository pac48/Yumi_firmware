FROM althack/ros2:humble-full

SHELL ["/bin/bash", "-c"]
RUN source /opt/ros/humble/setup.bash

RUN apt update
RUN apt -y install protobuf-compiler
WORKDIR /tmp
RUN git clone https://github.com/ros-industrial/abb_libegm.git
WORKDIR abb_libegm
RUN mkdir build 
WORKDIR build
RUN cmake ..
RUN make install

# clone source
ENV YUMI_WS /home/yumi_ws
RUN mkdir -p $YUMI_WS/src
WORKDIR $YUMI_WS/src
RUN git clone https://github.com/pac48/Yumi.git
WORKDIR Yumi
RUN git checkout ros2
WORKDIR $YUMI_WS

# get dependencies
RUN apt update
RUN rosdep update 
RUN rosdep install --from-paths src --ignore-src -y

# build source code
RUN colcon build --cmake-args --symlink-install
RUN source install/setup.bash

# copy entry pointer script
RUN apt install net-tools -y
RUN apt-get install iputils-ping -y
COPY ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["bash"]
