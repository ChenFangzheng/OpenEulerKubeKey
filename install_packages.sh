#!/bin/bash

rpm -ivh $(pwd)/packages/*.rpm --force --nodeps

ansible-galaxy collection install $(pwd)//kubernetes-core-6.1.0.tar.gz --force

pip install --no-index --find-links=$(pwd)/pip kubernetes PyYAML