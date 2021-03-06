#!/bin/bash

git describe --exact-match --tags $(git log -n1 --pretty='%h') >/dev/null 2>&1
if [[ $? != 0 ]]; then
    echo "Should not publish tags from an untagged commit!"
    exit 1
fi

cd $(git rev-parse --show-toplevel)
rm -rf target/doc/
multirust run nightly cargo doc --no-deps --features "load_extension trace"
echo '<meta http-equiv=refresh content=0;url=rusqlite/index.html>' > target/doc/index.html
ghp-import target/doc
git push origin gh-pages:gh-pages
