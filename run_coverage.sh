#!/bin/bash

# Function to run tests and coverage for a module
run_module_coverage() {
    local module=$1
    echo "Running tests and coverage for $module..."
    cd $module
    discover scan
    cd ..
    cd ..
}

# Run coverage for each module
echo "Starting test coverage scan..."
# run_module_coverage "modules/common"
run_module_coverage "modules/domain"
run_module_coverage "modules/data"
# run_module_coverage "app"

# Combine coverage reports
echo "Combining coverage reports..."
lcov --add-tracefile modules/domain/coverage/lcov.info \
     --add-tracefile modules/data/coverage/lcov.info \
     --output-file coverage/lcov.info

# Generate HTML report
echo "Generating HTML report..."
genhtml coverage/lcov.info -o coverage/html

echo "Coverage report generated in coverage/html" 