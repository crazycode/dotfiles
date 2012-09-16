#!/bin/sh
# 使在外接屏幕上字体显示清晰
defaults -currentHost write -globalDomain AppleFontSmoothing -int 2

# 关闭动画
defaults write com.apple.dock springboard-show-duration -int 0 
defaults write com.apple.dock springboard-hide-duration -int 0;killall Dock
defaults write com.apple.dock expose-animation-duration -int 0;killall Dock

# 默认使用本地目录打开文件，而不是iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

