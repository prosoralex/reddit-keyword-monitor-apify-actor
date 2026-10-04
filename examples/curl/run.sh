#!/usr/bin/env bash
# Run the "Reddit Scraper — Keyword & Subreddit Monitor" Apify Actor synchronously and print the dataset items.
# Usage: export APIFY_TOKEN=your_apify_token && ./run.sh
set -euo pipefail
: "${APIFY_TOKEN:?Set APIFY_TOKEN first (Apify Console > Settings > API & Integrations)}"

curl -sS -X POST "https://api.apify.com/v2/acts/leadsbrary~reddit-keyword-monitor/run-sync-get-dataset-items" \
  -H "Authorization: Bearer ${APIFY_TOKEN}" \
  -H "Content-Type: application/json" \
  -d @- <<'JSON'
{
  "keywords": [
    "web scraping"
  ],
  "subreddits": [
    "webscraping"
  ],
  "sort": "new",
  "timeFilter": "week",
  "includeComments": false,
  "maxCommentsPerPost": 10,
  "maxResults": 3,
  "proxyConfiguration": {
    "useApifyProxy": true,
    "apifyProxyGroups": [
      "RESIDENTIAL"
    ]
  }
}
JSON
