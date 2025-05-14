#!/bin/bash

cd /home/jetson/jetsonEnv

# Fetch latest changes from origin
git fetch origin

# Forcefully reset local repo to match the remote branch
git reset --hard origin/main
