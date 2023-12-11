#!/bin/bash

# Get the initial modification time of the script
last_modification=$(stat -c %Y $2)

while true; do
    # Get the current modification time of the script
    current_modification=$(stat -c %Y $2)

    # Check if the script has been modified
    if [ "$current_modification" -gt "$last_modification" ]; then
        echo "CHANGES DETECTED; RERUNNING..."

        # Run the script
        $*

        # Update the last modification time
        last_modification=$current_modification
    fi

    # Add a sleep to avoid continuous checking
    sleep 1
done

