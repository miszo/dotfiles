#!/bin/bash

op vault --account $2 get $1 --format json | jq ${3:-.id}
