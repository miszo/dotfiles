#!/bin/bash

op account --account "$1" get --format=json | jq "${2:-.id}"
