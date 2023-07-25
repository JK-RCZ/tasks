#!/usr/bin/env bash

mv /usr/share/java/jenkins.war /usr/share/java/$(cat /home/ec2-user/jenkins-previous-version.txt)