#!/bin/bash
set -e

# 部署設定
REPO="https://github.com/idkwhat7imdoing/winrate-simulator-v5.git"
BRANCH="gh-pages"
BUILD_DIR="deploy-temp"

echo "🚀 開始自動部署 winrate-simulator-v5 到 GitHub Pages..."

# 清理舊資料
rm -rf $BUILD_DIR
mkdir $BUILD_DIR

# 複製必要檔案（根據你的專案結構調整）
cp -r index.html style.css script.js $BUILD_DIR/

# 進入暫存資料夾
cd $BUILD_DIR
git init
git checkout -b $BRANCH
git add .
git commit -m "Auto deploy $(date)"
git push -f $REPO $BRANCH

cd ..
rm -rf $BUILD_DIR

echo "✅ 部署完成！"
echo "🌐 網站已更新：https://idkwhat7imdoing.github.io/winrate-simulator-v5/"
