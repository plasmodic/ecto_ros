#!/usr/bin/env python

from ecto_ros_test_utils import *
from test_reinit import *

if __name__ == "__main__":
    bagname = sys.argv[1]
    msg_counts = bag_counts(bagname)
    try:
        roscore = start_roscore(delay=1)
        for i in range(1, 10):
            do_ecto(bagname, msg_counts, ecto.schedulers.Threadpool)
    finally:
        roscore.terminate()
