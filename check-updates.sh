#! /bin/bash

urlencode () {
    echo "$1" | sed -E 's|/|%2F|g'
}

for m in ./frameworks/*/Makefile; do
    tag=$(dirname "$m" | sed -E 's|^[./]+||; s|/|--|g')
    ver=$(sed -En 's/^\s*PKG_SOURCE_VERSION\s*:=\s*([0-9a-f]{40})\s*$/\1/p' "$m") #'
    if [[ -f "./.cache/ver/$tag" ]]; then
        latest_repo_cid=$(<"./.cache/ver/$tag")
        [[ "$latest_repo_cid" =~ ^[0-9a-f]{40}$ ]] || { echo "unexpected stored latest repo commit id format '$latest_repo_cid' for repo https://invent.kde.org/$repo"; continue; }
    else
        repo=$(sed -En 's|^\s*PKG_SOURCE_URL\s*:=\s*https://invent.kde.org/(.+)\.git\s*$|\1|p' "$m") #'
        bref=$(sed -En 's|^\s*PKG_SOURCE_BRANCH_REF\s*:=\s*(\S+)\s*$|\1|p' "$m") #'
        mkdir -p "./.cache/ver"
        bref_url="https://invent.kde.org/api/v4/projects/$(urlencode "$repo")/repository/branches/$(urlencode "$bref")"
        curl -s "$bref_url" > "./.cache/ver/$tag.json" || { echo "failed fetch branch from url '$bref_url'"; continue; }
        latest_repo_cid=$(cat "./.cache/ver/$tag.json" | jq -r .commit.id)
        [[ "$latest_repo_cid" =~ ^[0-9a-f]{40}$ ]] || { echo "unexpected latest repo commit id format '$latest_repo_cid' for repo https://invent.kde.org/$repo"; continue; }
        echo "$latest_repo_cid" > "./.cache/ver/$tag"
    fi
    [[ "$ver" == "$latest_repo_cid" ]] && continue
    echo "$m $ver -> $latest_repo_cid"
done

for m in ./applications/*/Makefile; do
    tag=$(dirname "$m" | sed -E 's|^[./]+||; s|/|--|g')
    ver=$(sed -En 's/^\s*PKG_VERSION\s*:=\s*([0-9]+\.[0-9]+\.[0-9]+)\s*$/\1/p' "$m") #'
    if [[ -f "./.cache/ver/$tag" ]]; then
        latest_repo_ver=$(<"./.cache/ver/$tag")
        [[ "$latest_repo_ver" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "unexpected stored latest repo version format '$latest_repo_ver' for repo https://github.com/$owner/$repo"; continue; }
    else
        read owner repo <<<$(sed -En 's|^\s*PKG_SOURCE_URL\s*:=\s*https://github.com/([^/]+)/([^/]+)\.git$|\1 \2|p' "$m") #'
        [[ "$ver" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "unexpected version format '$ver' in file $m"; continue; }
        [[ -n "$owner" ]] || { echo "unknown repository owner in file $m"; continue; }
        [[ -n "$repo" ]] || { echo "unknown repository name in file $m"; continue; }
        mkdir -p "./.cache/ver"
        tags_url="https://api.github.com/repos/$owner/$repo/git/refs/tags"
        curl -s "$tags_url" > "./.cache/ver/$tag.json" || { echo "failed fetch tags from url '$tags_url'"; continue; }
        latest_repo_ver=$(cat "./.cache/ver/$tag.json" | jq -r '.[].ref' | sed -En 's|^refs/tags/([0-9]+\.[0-9]+\.[0-9]+)$|\1|p' | sort -n -t. -k1 -k2 -k3 -r | head -n1) #'
        [[ "$latest_repo_ver" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "unexpected latest repo version format '$latest_repo_ver' for repo https://github.com/$owner/$repo"; continue; }
        echo "$latest_repo_ver" > "./.cache/ver/$tag"
    fi
    [[ "$ver" == "$latest_repo_ver" ]] && continue
    echo "$m $ver -> $latest_repo_ver"
done
