// 首页控制器
%hook NewMainFrameViewController
- (void)initTableHeaderView {
    %orig;
    // 在这里重新给searchBar加上液态玻璃效果
}
- (void)setSearchBarToTableHeaderView {
    %orig;
    // 修复搜索框毛玻璃
}
%end

// 搜索栏本身
%hook WCSearchBar
- (void)setUnactiveStyle {
    %orig;
    // 修复非激活状态样式，强制玻璃效果
}
%end
