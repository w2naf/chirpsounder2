#!/bin/bash
session=chirpSounder2

tmux new-session -d -s $session 'htop';         # start new detached tmux session, run htop

tmux split-window;
#tmux send 'echo 1' ENTER;
tmux send './juha.sh' ENTER;

tmux select-layout even-vertical

tmux split-window -h -t 0;
#tmux send 'echo 2' ENTER;

tmux split-window -h -t 2;
#tmux send 'echo 3' ENTER;
tmux send 'tail -f thor.log' ENTER;

tmux a;                                         # open (attach) tmux session.
