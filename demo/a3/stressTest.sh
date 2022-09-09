#!/bin/bash

CONCURRENCY=4
REQUESTS=200
ADDRESS="http://localhost/app/"

for i in `seq 1 $CONCURRENCY`; do
  curl -s -o /dev/null "$ADDRESS?[1-$REQUESTS]" & pidlist="$pidlist $!"
done

# Execute and wait
FAIL=0
for job in $pidlist; do
  echo $job
  wait $job || let "FAIL += 1"
done

# Verify if any failed
if [ "$FAIL" -eq 0 ]; then
  echo "SUCCESS!"
else
  echo "Failed Requests: ($FAIL)"
fi