#!/usr/bin/env bash

set -x

echo "Checking grammar and style"
echo ""
write-good `find /docs -not \( -path /docs/drafts -prune \) -name '*.rst'` --passive --so --no-illusion --thereIs --cliches

echo "Checking links"
make linkcheck | grep "broken"
