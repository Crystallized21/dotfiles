#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Safari Approve Pull Request
# @raycast.mode compact

# Optional parameters:
# @raycast.icon ✅ 
# @raycast.packageName Developer Utils

# Documentation:
# @raycast.author Crystallized21
# @raycast.authorURL https://raycast.com/Crystallized21

# @raycast.argument1 { "type": "dropdown", "placeholder": "Approve", "data": [{"title": "Approve", "value": "1"},{"title": "Automerge", "value": "2"},{"title": "Force merge", "value": "3"},{"title": "Squash merge", "value": "4"}] }

url=`/Users/crystallized/.nvm/versions/node/v22.18.0/bin/safari-ctl`
repo=`echo $url | sed -e 's,https://github.com/[^/]*/\([^/^#]*\).*,\1,g'`
owner=`echo $url | sed -e 's,https://github.com/\([^/]*\)/[^/^#]*.*,\1,g'`

# cd ~/WebstormProjects/$repo/ > /dev/null 2>&1

eval "$(gh pr view $url --json "number,title,url,author" | jq -r '@sh "number=\(.number)", @sh "title=\(.title)", @sh "url=\(.url)", @sh "author=\(.author.login)"')"

if [[ -z "$title" ]]; then
  echo "Current tab is not a pull request!"
  exit 1
fi

username="Crystallized21"
reviews=$(gh api repos/$owner/$repo/pulls/$number/reviews)

if echo "$reviews" | jq --arg username "$username" '.[] | select(.user.login == $username) | select(.state == "APPROVED")' | grep -q 'APPROVED'; then
  reviewed=1;
else
  gh pr review $url -a
  reviewed=0;
fi

case "$1" in
    1)
        if [ $reviewed -eq 1 ]; then
            echo "Already approved!"
        else
            echo "Approved #$number ($title)"
        fi
        ;;
    2)
        gh pr merge $url --auto -m
        echo "Approved and automerged #$number ($title)"
        ;;
    3)
        gh pr merge $url --merge --disable-auto
        gh pr merge $url --merge --admin
        echo "Approved and force merged #$number ($title)"
        ;;
    4)
        gh pr merge $url --squash --admin
        echo "Approved and squash merged #$number ($title)"
        ;;
esac

osascript -e 'tell application "Safari" to do JavaScript "location.reload();" in document 1'
