#!/bin/bash

result=$(/usr/bin/nvidia-smi -L)

# If $result is null or empty, return empty JSON
if [ -z "$result" ]; then
  printf '%s' '{"data":[]}'
  exit 0
fi

declare -a gpu_entry_array

while IFS= read -r line; do
  index=$(echo "$line" | awk -F':| ' '{print $2}')
  gpuuuid=$(echo "$line" | grep -oP '(?<=UUID: )GPU-[^)]+')

  gpu_entry_array+=("{\"{#GPUINDEX}\":\"$index\", \"{#GPUUUID}\":\"$gpuuuid\"}")
done < <(printf '%s\n' "$result")

echo -e "{\n\"data\":[\n$(IFS=,; echo "${gpu_entry_array[*]}")\n]\n}"
