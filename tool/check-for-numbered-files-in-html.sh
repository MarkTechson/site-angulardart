#!/usr/bin/env bash

# `find` exit code reflects whether it encountered errors during the search.
# We ignore such errors, so don't exit on a pipefail.
# set -e -o pipefail

LOGFILE=$TMP/log-for-file-vers-check.txt

# Note: we ignore the component-loading Note since it contains foo_1 file names in its examples.

find publish -type f -name "*.html" -exec grep -E '_\d(\.template)?.(css|dart|html)' {} + \
  | grep -Ev 'angular/note/faq/component-loading.html:' \
  | grep -Ev 'code-(excerpt|pane)' > $LOGFILE

if [[ -s $LOGFILE ]]; then
  echo "ERROR: Some code excerpts refer to intermediate file versions, but they should not"
  echo "(e.g., see https://github.com/dart-lang/site-webdev/issues/1149):"
  echo
  cat $LOGFILE | sort
  exit 1
fi

exit 0
