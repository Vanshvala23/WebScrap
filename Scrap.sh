#!/bin/bash

# === Function to validate URL ===
function is_valid_url() {
    [[ $1 =~ ^https?://[a-zA-Z0-9.-]+(\.[a-zA-Z]{2,})+ ]]
}

# === Colors ===
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No color

# === Get URL from argument or prompt ===
if [ -n "$1" ]; then
    url="$1"
else
    read -p "Enter website URL (e.g., https://example.com): " url
fi

if ! is_valid_url "$url"; then
    echo -e "${RED} Invalid URL format.${NC}"
    exit 1
fi

# === Custom User-Agent ===
user_agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115 Safari/537.36"

# === Check status code ===
status_code=$(curl -s -o /dev/null -w "%{http_code}" -A "$user_agent" "$url")
if [[ "$status_code" -ne 200 ]]; then
    echo -e "${RED} Failed to fetch page. HTTP Status: $status_code${NC}"
    exit 1
fi

# === Fetch page content ===
html=$(curl -s -A "$user_agent" "$url")

# === Extract elements ===
title=$(echo "$html" | grep -oP '(?<=<title>).*?(?=</title>)' | head -n1 | sed 's/"/\\"/g')

links=$(echo "$html" | grep -oP '(?i)(?<=href=["'\''"])(http[s]?://[^"'\'' >]+)' | sort -u | sed 's/"/\\"/g' | sed 's/^/    "/;s/$/",/')

metas=$(echo "$html" | grep -oP '(?i)<meta[^>]+>' | grep -oP '(name|property|content)=["'\''"][^"'\''"]+["'\''"]' | sort -u | sed 's/"/\\"/g' | sed 's/^/    "/;s/$/",/')
headings=$(echo "$html" | grep -oP '(?<=<h1[^>]*>).*?(?=</h1>)' | sed 's/<[^>]*>//g' | sed 's/"/\\"/g' | sed 's/^/    "/;s/$/",/')

# === Images ===
raw_images=$(echo "$html" | grep -oiP '<img[^>]+src=["'\''][^"'\'' >]+["'\'']' | grep -oiP 'src=["'\''][^"'\'' >]+' | cut -d'"' -f2)
# Normalize image URLs (handle relative paths)
images=""
for img in $raw_images; do
    if [[ "$img" =~ ^http ]]; then
        full_url="$img"
    else
        full_url=$(python3 -c "from urllib.parse import urljoin; print(urljoin('$url', '$img'))")
    fi
    images+=$(printf '    "%s",\n' "$(echo "$full_url" | sed 's/"/\\"/g')")
done

# Remove trailing comma
images=$(echo "$images" | sed '$ s/,$//')

# === Remove trailing commas ===
links=$(echo "$links" | sed '$ s/,$//')
images=$(echo "$images" | sed '$ s/,$//')
metas=$(echo "$metas" | sed '$ s/,$//')
headings=$(echo "$headings" | sed '$ s/,$//')

# === Build JSON ===
json_output=$(cat <<EOF
{
  "url": "$url",
  "status_code": $status_code,
  "title": "$title",
  "headings": [
$headings
  ],
  "links": [
$links
  ],
  "images": [
$images
  ],
  "meta_tags": [
$metas
  ]
}
EOF
)

# === Output ===
echo -e "\n${CYAN} JSON Output:${NC}"

# If jq is installed, pretty-print
if command -v jq &>/dev/null; then
    echo "$json_output" | jq .
else
    echo "$json_output"
fi

# === Save to file ===
timestamp=$(date +%Y%m%d_%H%M%S)
outfile="scrape_output_$timestamp.json"
echo "$json_output" > "$outfile"
echo -e "\n${GREEN} JSON saved to: $outfile${NC}"
