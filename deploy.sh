#!/usr/bin/env bash
set -e

# Gå til projektmappen
cd "$(dirname "$0")"

echo "🦀 Bygger Zola site..."
zola build

echo "🚀 Uploader til hajsdocker..."
rsync -avz --delete public/ hajsdocker:~/web-rejser/public/

echo "✅ Udrulning fuldført!"
echo "🌐 Live på: http://172.104.143.80:8085/"
