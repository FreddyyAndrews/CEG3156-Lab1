#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path_to_vhdl_file> <path_to_test_bench_file>"
    exit 1
fi

# Get the file paths
VHDL_FILE=$1
TEST_BENCH_FILE=$2

# Extract entity names from the file names
ENTITY_NAME=$(basename "$VHDL_FILE" .vhdl)
TEST_ENTITY_NAME=$(basename "$TEST_BENCH_FILE" .vhdl)

# Compile the VHDL file
echo "Compiling $VHDL_FILE..."
ghdl -a "$VHDL_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Compilation of $VHDL_FILE failed."
    exit 1
fi

# Compile the test bench file
echo "Compiling $TEST_BENCH_FILE..."
ghdl -a "$TEST_BENCH_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Compilation of $TEST_BENCH_FILE failed."
    exit 1
fi

# Elaborate the test bench entity
echo "Elaborating $TEST_ENTITY_NAME..."
ghdl -e "$TEST_ENTITY_NAME"
if [ $? -ne 0 ]; then
    echo "Error: Elaboration of $TEST_ENTITY_NAME failed."
    exit 1
fi

# Run the simulation
echo "Running simulation for $TEST_ENTITY_NAME..."
ghdl -r "$TEST_ENTITY_NAME" --wave=${TEST_ENTITY_NAME}_waveform.ghw
if [ $? -ne 0 ]; then
    echo "Error: Simulation of $TEST_ENTITY_NAME failed."
    exit 1
fi

# Output success and instructions for waveform viewing
echo "Simulation completed successfully."
echo "To view the waveform, run: gtkwave ${TEST_ENTITY_NAME}_waveform.ghw"
