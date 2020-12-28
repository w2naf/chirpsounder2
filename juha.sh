#!/usr/bin/bash
#
# analyze unknown ionograms serendipitously (start analyzing when a new chirp is detected)
#
# try to fix possible overheating problem by restricting the cpu clock frequency
echo 70 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct
echo 70 | sudo tee /sys/devices/system/cpu/intel_pstate/min_perf_pct

#
# make sure this is the right mpirun command (you might need mpirun instead of mpirun.mpich)
MPIRUN=mpirun

# ram disk buffer for fast i/o.
# if you have a fast SSD or raid, you can also use that
RINGBUFFER_DIR=/mnt/ramdisk/hf25
SAMPLE_RATE=25e6
CENTER_FREQ=12.5e6
CONF_FILE=juha.ini
# make this about 200 MB less than half your RAM size
# with an SSD this can be more
# more is better, as we can analyze more
RINGBUFFER_SIZE=42000MB
# start a ringbuffer
#

rm -Rf $RINGBUFFER_DIR
#thor.py -m 192.168.10.2 -d A:A -c cha -f $CENTER_FREQ -r $SAMPLE_RATE $RINGBUFFER_DIR &
sh thor_kludge.sh > thor.log 2>&1 &
sleep 10

drf ringbuffer -z $RINGBUFFER_SIZE $RINGBUFFER_DIR -p 2 > ringbuffer.log 2>&1 &
sleep 10

# detect chirps
# two processes seems to be enough to keep up with realtime
$MPIRUN -np 2 python detect_chirps.py $CONF_FILE > detect.log 2>&1 &
sleep 10

# find timings
python find_timings.py $CONF_FILE > timings.log 2>&1 &
sleep 10

# calculate ionograms
# seems like four parallel processes work.
# this means we can process four ionograms simultaneously!
$MPIRUN -np 4 python calc_ionograms.py $CONF_FILE > ionograms.log 2>&1 &
sleep 10

# plot ionograms
python plot_ionograms.py $CONF_FILE &
