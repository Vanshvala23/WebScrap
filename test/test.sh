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

# Prompt user for a URL (valid or invalid)
read -p "Enter a URL for testing (can be valid or invalid): " url

# Test the provided URL (valid or invalid)
test_url "$url"

echo "Test completed!"
