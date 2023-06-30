#!/usr/bin/env bash

source ./dokku-functions.sh

list_apps dokku-01.cs.ucsb.edu

matching_apps dokku-01.cs.ucsb.edu "^jpa03-.*$"