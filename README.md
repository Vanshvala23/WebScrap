# Bash Web Scraper

A lightweight, terminal-based **web scraping tool** written entirely in Bash that extracts essential website data and outputs it in a clean **JSON format**.

This tool is perfect for quick inspection of a webpage's structure — including links, images, meta tags, and headings — without needing Python or JavaScript-heavy frameworks.

This tools is also useful for developers who trying to get data from any website.

---

## 🚀 Features

- ✅ Validate and fetch from any `http` or `https` URL
- 🏷️ Extracts:
  - Page `<title>`
  - All `<h1>` headings
  - All hyperlinks (`<a href="">`)
  - All image sources (`<img src="">`, including relative URLs resolved)
  - Meta tags (`<meta name|property|content="">`)
- 📦 Outputs clean JSON
- 💄 Pretty prints with `jq` if available
- 📁 Saves output as `scrape_output_YYYYMMDD_HHMMSS.json`

---

## 📥 Installation

No dependencies required for core features. You just need:

- `bash`
- `curl`
- `grep`, `sed`, `sort`
- `python3` (for resolving relative image URLs)
- `jq` *(optional)* for prettier output

Clone this repo:

```bash
git clone https://github.com/Vanshvala23/WebScrap.git
cd bash-web-scraper
chmod +x Scrap.sh
```
## Future Expansion
In future this project would be shared with an android app called "SiteSniffer" but its under development.
