# Reddit Scraper — Keyword & Subreddit Monitor — Apify Actor usage guide

[![Run on Apify](https://img.shields.io/badge/Apify-Run%20this%20Actor-24C1E0)](https://apify.com/leadsbrary/reddit-keyword-monitor?fpr=aupara)
[![Try Apify free](https://img.shields.io/badge/Apify-Try%20it%20free-24C1E0)](https://console.apify.com/sign-up?fpr=aupara)

Reddit scraper that monitors keywords and subreddits: returns post title, body, author, date, URL, matched keywords and optional comments as JSON, CSV or Excel. From $1.00 per 1,000 results.

> **This repository does not contain the Actor's source code.** The Actor is closed-source and
> runs on Apify's infrastructure. This repo is documentation plus ready-to-run client examples
> (curl, Python, JavaScript) that call the hosted Actor with **your own** Apify API token.

**Run it on Apify →** [https://apify.com/leadsbrary/reddit-keyword-monitor?fpr=aupara](https://apify.com/leadsbrary/reddit-keyword-monitor?fpr=aupara)

## What it does

Give the Actor keywords, subreddits, or both. It reads Reddit's public Atom/RSS feeds, pages through them, removes duplicates (a post matching several keywords is returned once, with all matched keywords listed) and stores one dataset row per post.

- Keywords only: Reddit-wide search for each keyword.
- Subreddits only: the newest posts of each subreddit (or hot/top if you choose that sort).
- Keywords + subreddits: search restricted to those subreddits.
- Schedule it with a time window (`maxAgeHours` or `postedAfter`) to get only what is new since the last run.

## Use cases

- Brand / product / competitor mention monitoring across all of Reddit or a list of subreddits, run on an Apify schedule
- Lead generation: find fresh posts expressing a pain point ('looking for a tool to …', 'alternative to X')
- RAG / LLM knowledge feed: recent community discussion on a topic, with a pre-built `text` field ready for chunking and embedding
- Market and trend research: what a niche subreddit talks about this week, from post titles, text and optional comment text


## Input

| Field | Type | Required | Description |
|---|---|---|---|
| `keywords` | array | no | Search terms (Reddit search syntax allowed, e.g. "exact phrase"). Each keyword is searched separately; posts matching several keywords are returned once. Provide keywords and/or subreddits. |
| `subreddits` | array | no | Subreddit names (webscraping, r/webscraping or a full URL). With keywords: search restricted to these subreddits. Without keywords: the newest posts of each subreddit. |
| `sort` | string | no | 'new' is the monitoring default. Other options use the time window below. |
| `timeFilter` | string | no | Reddit time window, used when Sort is not 'new'. |
| `maxAgeHours` | integer | no | Monitoring mode for scheduled runs: skip posts older than this many hours. |
| `postedAfter` | string | no | e.g. 2026-10-01T00:00:00Z. Takes precedence over 'Only posts from the last N hours'. |
| `includeComments` | boolean | no | Attach the first comments of each post (one extra request per post). |
| `maxCommentsPerPost` | integer | no | Used when 'Include comments' is on. |
| `maxResults` | integer | no | Maximum posts across all keywords/subreddits (each post is one billed result). |
| `proxyConfiguration` | object | no | Reddit rate-limits feed requests per IP; the Actor uses a fresh IP per request. Residential proxy recommended. |

The full input form (with defaults and validation) is on the [Actor page](https://apify.com/leadsbrary/reddit-keyword-monitor?fpr=aupara).


## Output (sample item)

Sample trimmed for readability (long texts and lists are shortened) — a real run returns the complete data.

```json
{
  "type": "post",
  "id": "1wwjnov",
  "url": "https://www.reddit.com/r/webscraping/comments/1wwjnov/local_clicktocsv_chrome_extension_no_cloud_no/",
  "title": "Local click-to-CSV Chrome extension (no cloud, no account)",
  "body": "I kept writing one-off scripts just to grab a table off a page. LucidRows is the small version of that: open the page, click the columns you want, preview the rows, export CSV.\n\nIt runs in your browser. No account, no cloud scrape, and the local tool stays free. It is for the pag…",
  "linkUrl": null,
  "subreddit": "webscraping",
  "author": "IngenuityHuge5998",
  "createdAt": "2026-10-03T10:10:25.000Z",
  "score": null,
  "numComments": null,
  "flair": null,
  "isNsfw": false,
  "matchedKeywords": [
    "web scraping"
  ],
  "source": "search",
  "comments": null,
  "text": "Local click-to-CSV Chrome extension (no cloud, no account)\n\nI kept writing one-off scripts just to grab a table off a page. LucidRows is the small version of that: open the page, click the columns you want, preview the rows, export CSV.\n\nIt runs in your browser. No account, no cl…",
  "scrapedAt": "2026-10-03T23:29:01.966Z"
}
```

## Pricing

Pay only for results: about **$1.50 per 1,000 results** on the Apify Free plan, down to **$1.00 per 1,000** on paid Apify plans.

Apify platform usage (compute and residential proxy traffic) is billed by Apify on top of the per-result price — about **$0.19 per 1,000 results** in our measured test runs (estimate, varies with input). Tip: keep only the output formats and options you need to reduce it.

Prices can change — the [Actor page](https://apify.com/leadsbrary/reddit-keyword-monitor?fpr=aupara) always shows the current pricing.

## Quick start

You need an Apify account and an API token (Apify Console → **Settings → API & Integrations**).
Never commit your token: export it as the `APIFY_TOKEN` environment variable.

### cURL

```bash
curl -X POST "https://api.apify.com/v2/acts/leadsbrary~reddit-keyword-monitor/run-sync-get-dataset-items" \
  -H "Authorization: Bearer $APIFY_TOKEN" \
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
```

### Python (`apify-client`)

```python
import os
from apify_client import ApifyClient

client = ApifyClient(os.environ["APIFY_TOKEN"])

run_input = {
    "keywords": [
        "web scraping"
    ],
    "subreddits": [
        "webscraping"
    ],
    "sort": "new",
    "timeFilter": "week",
    "includeComments": False,
    "maxCommentsPerPost": 10,
    "maxResults": 3,
    "proxyConfiguration": {
        "useApifyProxy": True,
        "apifyProxyGroups": [
            "RESIDENTIAL"
        ]
    }
}

run = client.actor("leadsbrary/reddit-keyword-monitor").call(run_input=run_input)
for item in client.dataset(run["defaultDatasetId"]).iterate_items():
    print(item)
```

### JavaScript (`apify-client`)

```javascript
import { ApifyClient } from 'apify-client';

const client = new ApifyClient({ token: process.env.APIFY_TOKEN });

const runInput = {
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
};

const run = await client.actor('leadsbrary/reddit-keyword-monitor').call(runInput);
const { items } = await client.dataset(run.defaultDatasetId).listItems();
console.log(items);
```

Runnable versions live in [`examples/`](./examples).

## Troubleshooting

- **401 / "User was not found or authentication token is not valid"** — check that `APIFY_TOKEN` is set and copied completely.
- **The run finished but the dataset is empty** — widen your search input or check the run log on the Apify Console.
- **Run stops early** — you may have reached the maximum cost per run you set in Apify; raise it in the run options.
- **Need something else?** Open an issue in this repository or use the Issues tab on the Actor page.

## Don't have an Apify account yet?

[Sign up here](https://console.apify.com/sign-up?fpr=aupara) — new accounts get $5 of free platform usage every month, enough to try most Actors without paying upfront.
Browse the full [Apify Store](https://apify.com/store?fpr=aupara) or [all Actors from this developer](https://apify.com/leadsbrary?fpr=aupara).

## Links

- Actor page: [https://apify.com/leadsbrary/reddit-keyword-monitor?fpr=aupara](https://apify.com/leadsbrary/reddit-keyword-monitor?fpr=aupara)
- All Actors from this developer: [https://apify.com/leadsbrary?fpr=aupara](https://apify.com/leadsbrary?fpr=aupara)
- Apify API reference: [https://docs.apify.com/api/v2](https://docs.apify.com/api/v2)

## Keywords

reddit scraper, reddit keyword monitor, reddit monitoring, reddit search scraper, subreddit scraper, reddit brand monitoring, reddit mentions tracker, reddit posts scraper, reddit comments scraper, reddit lead generation, reddit data for rag, reddit to json, social listening reddit

#reddit #redditscraper #keywordmonitoring #sociallistening #brandmonitoring #leadgeneration #rag #llm #webscraping #apify

## License

The example code in this repository is released under the MIT License — see [LICENSE](./LICENSE).
It does not cover the Actor itself, which remains closed-source and is operated by its developer on Apify.
