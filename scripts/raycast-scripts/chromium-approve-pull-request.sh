#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Chromium Approve Pull Request
# @raycast.mode compact

# Optional parameters:
# @raycast.icon ☑️
# @raycast.packageName Developer Utils

# Documentation:
# @raycast.author Crystallized21
# @raycast.authorURL https://raycast.com/Crystallized21

# @raycast.argument1 { "type": "dropdown", "placeholder": "Action", "data": [{"title": "Approve", "value": "approve"},{"title": "Automerge", "value": "automerge"},{"title": "Force merge", "value": "force"},{"title": "Squash merge", "value": "squash"}] }

set -euo pipefail

get_chromium_url() {
  /usr/bin/osascript <<'APPLESCRIPT'
tell application "System Events"
  set frontApp to name of first application process whose frontmost is true
end tell

if frontApp is "Google Chrome" then
    tell application "Google Chrome"
        return URL of active tab of front window
    end tell
else if frontApp is "Arc" then
    tell application "Arc"
        return URL of active tab of front window
    end tell
else
    error "Front app is not Chrome or Arc"
end if
APPLESCRIPT
}

url=$(get_chromium_url 2>/dev/null) || {
  echo "Front app is not Chrome or Arc, or no URL available."
  exit 1
}

if [[ "$url" =~ github\.com/([^/]+)/([^/]+)/pull/([0-9]+) ]]; then
    owner="${BASH_REMATCH[1]}"
    repo="${BASH_REMATCH[2]}"
    number="${BASH_REMATCH[3]}"
else
    echo "Current tab is not a PR URL!"
    exit 1
fi

pr_info=$(gh pr view "$url" --repo "$owner/$repo" --json number,title,author)
title=$(echo "$pr_info" | jq -r '.title')
author=$(echo "$pr_info" | jq -r '.author.login')

case "${1:-approve}" in
    approve)
        gh pr review "$url" -a
        echo "Approved #$number ($title)"
        ;;
    automerge)
        gh pr merge "$url" --auto -m
        echo "Approved and automerged #$number ($title)"
        ;;
    force)
        gh pr merge "$url" --merge --disable-auto --admin
        echo "Approved and force merged #$number ($title)"
        ;;
    squash)
        gh pr merge "$url" --squash --admin
        echo "Approved and squash merged #$number ($title)"
        ;;
    *)
        echo "Unknown action: $1"
        exit 1
        ;;
esac

/usr/bin/osascript <<'APPLESCRIPT'
tell application "System Events"
  set frontApp to name of first application process whose frontmost is true
end tell

if frontApp is "Google Chrome" then
    tell application "Google Chrome"
        tell active tab of front window to reload
    end tell
else if frontApp is "Arc" then
    tell application "Arc"
        tell active tab of front window to reload
    end tell
end if
APPLESCRIPT
