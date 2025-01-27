#!/bin/bash

# Directories
CONFIG_DIR="./configs"         # Directory containing configuration files
BENCHMARK_DIR="./benchmarks"   # Directory containing subdirectories with benchmark files
OUTPUT_DIR="./outputs"         # Directory to store simulation results
SIMULATOR="../simplesim-3.0/sim-cache"    # Path to the SimpleScalar simulator

# Check if required directories exist
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Config directory not found: $CONFIG_DIR"
    exit 1
fi

if [ ! -d "$BENCHMARK_DIR" ]; then
    echo "Benchmark directory not found: $BENCHMARK_DIR"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through each configuration file (.txt files)
for config_file in "$CONFIG_DIR"/*.txt; do
    config_name=$(basename "$config_file" .txt)  # Get the config name without extension

    # Loop through each subfolder in the benchmark directory
    for folder in "$BENCHMARK_DIR"/*/; do
        # Loop through each .ss file in the subfolder
        for ss_file in "$folder"/*.ss; do
            # Find the corresponding li.lsp file by replacing .ss with .lsp
            lsp_file="${ss_file%.ss}.lsp"

            # Check if the corresponding li.lsp file exists
            if [ ! -f "$lsp_file" ]; then
                echo "Matching li.lsp file not found for $ss_file"
                continue
            fi

            benchmark_name=$(basename "$ss_file" .ss)  # Get the benchmark name
            folder_name=$(basename "$folder")           # Get the subfolder name (e.g., "li" or "li2")

            # Define output file
            output_file="$OUTPUT_DIR/${config_name}_${benchmark_name}.txt"

            echo "Simulating: Config=$config_name, Benchmark=$benchmark_name in Folder=$folder_name"

            # Run simulation with li.ss and li.lsp
            $SIMULATOR -config "$config_file" -redir:sim "$output_file" "$ss_file" "$lsp_file"

            if [ $? -eq 0 ]; then
                echo "Simulation complete: Output saved to $output_file"
            else
                echo "Simulation failed: Config=$config_name, Benchmark=$benchmark_name"
            fi
        done
    done
done

echo "All simulations complete. Results stored in $OUTPUT_DIR."
