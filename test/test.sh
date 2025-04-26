#!/bin/bash

set -e
echo "Running automated testing for SiteSniffer......"

SCRIPT="Scrap.sh"

test_user_input_url() {
    url=$1  # Take URL as an argument
    if output=$($SCRIPT "$url"); then
        echo "$output" | grep -q '"url"' && \
        echo "$output" | grep -q '"status_code"' && \
        echo "$output" | grep -q '"title"' && \
        echo "Test Passed: JSON contains expected fields"
    else
        echo "Test Failed: Invalid URL or script error"
        exit 1
    fi
}

# Detect if running in GitHub Actions
if [ "$GITHUB_ACTIONS" == "true" ]; then
    echo "Detected GitHub Actions environment."
    url="https://example.com"
else
    # Local environment - ask user
    read -p "Enter the URL to test: " url
fi

test_user_input_url "$url"

echo "All tests passed!"
