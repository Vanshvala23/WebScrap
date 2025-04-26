#!/bin/bash

set -e 
echo "Running automated testing for SiteSniffer......"

SCRIPT="../Scrap.sh"

# Function to test the URL
test_url() {
    local url="$1"
    
    # Check if URL is valid
    if [[ ! "$url" =~ ^https?://[a-zA-Z0-9.-]+(\.[a-zA-Z]{2,})+ ]]; then
        echo "❌ Invalid URL: $url"
        exit 1
    fi

    # If valid, run Scrap.sh and check the output
    echo "Running with URL: $url"
    output=$($SCRIPT "$url")
    
    # Check if output contains the expected fields
    echo "$output" | grep -q '"url"' && \
    echo "$output" | grep -q '"status_code"' && \
    echo "$output" | grep -q '"title"' && \
    echo "✅ Test Passed: JSON contains expected fields" || \
    {
        echo "❌ Test Failed: Missing expected JSON fields"
        exit 1
    }
}

# Predefined test cases
TEST_CASES=(
    "https://example.com"
    "https://invalid-url"
)

for url in "${TEST_CASES[@]}"; do
    test_url "$url"
done

echo "All tests completed!"