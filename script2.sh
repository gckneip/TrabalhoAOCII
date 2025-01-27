#!/bin/bash

# Directory containing the files
INPUT_DIR="./configs"  # Replace with the actual path to your folder
OUTPUT_DIR="./outputs"  # Replace with the desired output folder path

# Ensure the output directory exists
#mkdir -p "$OUTPUT_DIR"

# Iterate through each file in the input directory
for inputfile in "$INPUT_DIR"/*; do
    # Get the base name of the file (without path)
    base_name=$(basename "$inputfile")

    # Create a corresponding output file name
    outputfile="$OUTPUT_DIR/${base_name%.txt}_jpeg.txt"  # Customize extension if needed

    # Run the command
    ../simplesim-3.0/sim-cache \
        -config "$inputfile" \
        -redir:sim "$outputfile" \
        ./benchmarks/jpeg/ijpeg.ss \
        -image_file ./benchmarks/jpeg/tinyrose.ppm \
        -compression.quality 90 \
        -compression.optimize_coding 0 \
        -compression.smoothing_factor 90 \
        -difference.image 1 \
        -difference.x_stride 10 \
        -difference.y_stride 10 \
        -verbose 1 \
        -GO.findoptcomp
done

echo "Processing complete. Outputs saved to $OUTPUT_DIR"

