#!/usr/bin/env python
import ecto
import ecto_ros, ecto_sensor_msgs
from ecto_opencv import highgui
import sys
from ecto_ros_test_utils import *

ImageSub = ecto_sensor_msgs.Subscriber_Image
CameraInfoSub = ecto_sensor_msgs.Subscriber_CameraInfo

subs = dict(
            image=ImageSub(topic_name='/camera/rgb/image_color', queue_size=0),
            depth=ImageSub(topic_name='/camera/depth/image', queue_size=0),
            depth_info=CameraInfoSub(topic_name='/camera/depth/camera_info', queue_size=0),
            image_info=CameraInfoSub(topic_name='/camera/rgb/camera_info', queue_size=0),
         )

sync = ecto_ros.Synchronizer('Synchronizator', subs=subs
                             )
counter_rgb = ecto.Counter()
counter_depth = ecto.Counter()
counter_rgb_info = ecto.Counter()
counter_depth_info = ecto.Counter()

graph = [
            sync["image"] >> counter_rgb[:],
            sync["depth"] >> counter_depth[:],
            sync["image_info"] >> counter_rgb_info[:],
            sync["depth_info"] >> counter_depth_info[:],
        ]
plasm = ecto.Plasm()
plasm.connect(graph)


