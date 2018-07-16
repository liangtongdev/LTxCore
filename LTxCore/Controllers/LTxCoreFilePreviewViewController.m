//
//  LTxCoreFilePreviewViewController.m
//  LTxCore
//
//  Created by liangtong on 2018/7/16.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxCoreFilePreviewViewController.h"
#import <QuickLook/QuickLook.h>//文件预览
#import <AVFoundation/AVFoundation.h>//视频播放
#import <WebKit/WebKit.h>//网页预览
#import "LTxCoreDownloadTaskService.h"//下载相关
#import "LTxCoreFileManager.h"//文件管理

@interface LTxCoreFilePreviewSlider:UISlider
@property (nonatomic, strong) UIButton* leftBtn;
@property (nonatomic, strong) UILabel* timeL;
@property (nonatomic, copy) LTxCallbackBlock btnCallback;
@end

#define LTxCoreFilePreviewSliderBtnWidth 50
#define LTxCoreFilePreviewSliderTimeWidth 90
@implementation LTxCoreFilePreviewSlider
// 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
- (CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(LTxCoreFilePreviewSliderBtnWidth, CGRectGetHeight(bounds) / 2 - 5, CGRectGetWidth(self.frame) - (LTxCoreFilePreviewSliderBtnWidth + LTxCoreFilePreviewSliderTimeWidth), 10);
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _leftBtn = [[UIButton alloc] init];
        [self addSubview:_leftBtn];
        [_leftBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [_leftBtn setImage:LTxImageWithName(@"ic_file_preview_video_play") forState:UIControlStateSelected];
        [_leftBtn setImage:LTxImageWithName(@"ic_file_preview_video_pause") forState:UIControlStateNormal];
        _timeL = [[UILabel alloc] init];
        [self addSubview:_timeL];
        _timeL.textColor = [UIColor whiteColor];
        _timeL.font = [UIFont systemFontOfSize:14.f];
        _timeL.textAlignment = NSTextAlignmentCenter;
        
        [self setThumbImage:LTxImageWithName(@"ic_file_preview_video_slider_thumb") forState:UIControlStateNormal];
        self.minimumTrackTintColor = [LTxCoreConfig sharedInstance].skinColor;
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    _leftBtn.frame = CGRectMake(0, 0, LTxCoreFilePreviewSliderBtnWidth, CGRectGetHeight(rect));
    _timeL.frame = CGRectMake(CGRectGetWidth(rect) - LTxCoreFilePreviewSliderTimeWidth, 0, LTxCoreFilePreviewSliderTimeWidth, CGRectGetHeight(rect));
}
-(void)btnPressed:(UIButton*)btn{
    if (self.btnCallback) {
        self.btnCallback();
    }
}
@end

@interface LTxCoreFilePreviewViewController ()<UIDocumentInteractionControllerDelegate,QLPreviewControllerDataSource,WKNavigationDelegate>

/**第三方应用分享**/
@property (nonatomic, strong) UIButton* shareBtn;//第三方应用打开按钮，如果文件不使用第三方应用打开，则该按钮无效。
@property (nonatomic, strong) UIDocumentInteractionController* docInteractionController;//第三方应用打开

/**QuickLook**/
@property (nonatomic, strong) QLPreviewController* qlPreviewVC;

/**音频/视频播放**/
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) id avPlayerObserver;
@property (nonatomic, strong) LTxCoreFilePreviewSlider* playerSlider;//播放进度条

/**网页**/
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation LTxCoreFilePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化页面
    [self setupPreviewView];
}

-(void)dealloc{
    if(_progressView){//进度
        [_progressView removeFromSuperview];
    }
    [self dellocAVPlayer];//释放视频播放相关资源
    [self dellocWebView];//释放网页相关资源
    [[NSNotificationCenter defaultCenter] removeObserver:self];//通知
}

#pragma mark - 初始化
/**
 * 页面初始化
 * （1）是否需要第三方应用分享
 * （2）判断是否是本地/在线文件的预览 -> 页面展示控件初始化
 **/
-(void)setupPreviewView{
    //是否需要第三方应用打开
    if (_shareWithOtherApp) {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, LTxNavigationBarItemSize, LTxNavigationBarItemSize)];
        [_shareBtn addTarget:self action:@selector(openWithOtherApp) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtn setImage:LTxImageWithName(@"ic_navi_share_other_app") forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_shareBtn];
    }
    //如果是本地文件，直接根据文件格式来初始化页面展示控件
    if(_filePath){
        [self setupPreviewViewContent];
        return;
    }
    
    //如果是在线文件，则判断是否需要先下载
    if (_fileURL) {
        if(_needToDownload){//需要下载，则先下载文件，下载完成后，再初始化页面展示控件
            [self setupProgressView];//进度条
            [self addNotification];//通知
            NSString* fileSaveName = _fileURL.absoluteString.lastPathComponent;
            NSString* oldFilePath = [LTxCoreFileManager cacheFilePathWithName:fileSaveName];
            if (_preferCache) {
                if ([LTxCoreFileManager fileExistsAtPath:oldFilePath]) {
                    //优先使用缓存，此时不在进行下载动作
                    if(_progressView){//进度
                        [_progressView removeFromSuperview];
                    }
                    
                    _filePath = [NSURL fileURLWithPath:oldFilePath];
                    [self setupPreviewViewContent];
                    return;
                }
            }
            
            [LTxCoreFileManager removeItemAtPath:oldFilePath];
            [[LTxCoreDownloadTaskService sharedInstance] addDownloadTaskWithURL:_fileURL.absoluteString pathInSandbox:LTX_CORE_FILE_PREVIEW_CACHE_RELATIVE_PATH saveName:fileSaveName unzip:@0 queryCallback:^BOOL(LTxCoreTaskAddQueryState state) {
                [LTxCorePopup showToast:@"任务已经处于下载列表中！" onView:self.view];
                return YES;
            }];
            
        }else{//不需要下载，直接初始化页面展示控件
            _filePath = _fileURL;
            [self setupPreviewViewContent];
        }
        return;
    }
    
}

/**
 * 页面展示控件初始化
 **/
-(void)setupPreviewViewContent{
    NSString* urlString = [_filePath absoluteString];
    //导航栏标题
    if (!self.title) {
        self.title = [[[_filePath absoluteString] lastPathComponent] stringByDeletingPathExtension];
    }
    LTxCoreFileType fileType = [LTxCoreFile fileTypeWithURL:urlString];
    //对图片和文档，统一使用QuickLook进行文件预览
    if (fileType == LTxCoreFileTypeImage || fileType == LTxCoreFileTypeDocument) {
        if (_qlPreviewVC) {
            [_qlPreviewVC.view removeFromSuperview];
            [_qlPreviewVC removeFromParentViewController];
        }
        _qlPreviewVC = [[QLPreviewController alloc] init];
        _qlPreviewVC.dataSource = self;
        _qlPreviewVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addChildViewController:_qlPreviewVC];
        [self.view addSubview:_qlPreviewVC.view];
        [self addConstraintOnView:_qlPreviewVC.view];
    }else if (fileType == LTxCoreFileTypeVideo){
        //音频/视频播放时，背景置为黑色
        self.view.backgroundColor = [UIColor blackColor];
        
        self.player = [AVPlayer playerWithURL:_fileURL];
        [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        self.playerLayer = [[AVPlayerLayer alloc] init];
        self.playerLayer.frame = self.view.bounds;
        [self.view.layer addSublayer:self.playerLayer];
        
        self.playerLayer.player = _player;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        
        [self observeAVPlayerProgress];
        
        //进度条
        _playerSlider = [[LTxCoreFilePreviewSlider alloc] init];
        _playerSlider.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_playerSlider];
        [self addAVPlayerSliderConstraint];
        
        __weak __typeof(self) weakSelf = self;
        self.playerSlider.btnCallback = ^{
            weakSelf.playerSlider.leftBtn.selected = !weakSelf.playerSlider.leftBtn.selected;
            if (!weakSelf.playerSlider.leftBtn.selected) {
                [weakSelf play];
            }else{
                [weakSelf pause];
            }
        };
        [self.playerSlider addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAVPlayerGesture:)]];
        [self.playerSlider addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleAVPlayerGesture:)]];
    }else{
        //其他情况下，默认使用网页打开
        [self setupProgressView];//进度条
        _webView = [[WKWebView alloc] init];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        [_webView loadRequest:[NSURLRequest requestWithURL:_fileURL]];
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
        [self.view sendSubviewToBack:_webView];
        [self addConstraintOnView:_webView];
        
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

#pragma mark - 网络监听
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveLocalNotification:) name:LTX_CORE_DOWNLOAD_TASK_PROGRESS_UPDATE_KEY object:nil];//下载进度更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveLocalNotification:) name:LTX_CORE_DOWNLOAD_TASK_STATE_UPDATE_KEY object:nil];//下载完成
}
-(void)recieveLocalNotification:(NSNotification*)notification{
    NSString* notificationKeyName = [notification name];
    NSString* url = _fileURL.absoluteString;
    NSDictionary* obj = notification.object;
    if ([notificationKeyName isEqualToString:LTX_CORE_DOWNLOAD_TASK_PROGRESS_UPDATE_KEY]) {//下载进度更新
        NSString* progressUrl = [obj objectForKey:@"url"];
        if ([progressUrl isEqualToString:url]) {
            self.progressView.hidden = NO;
            CGFloat progress = [[obj objectForKey:@"value"] floatValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.progress = progress;
            });
        }
    }else if ([notificationKeyName isEqualToString:LTX_CORE_DOWNLOAD_TASK_STATE_UPDATE_KEY]) {//下载完成
        NSString* progressUrl = [obj objectForKey:@"url"];
        if ([progressUrl isEqualToString:url]) {
            self.progressView.hidden = YES;
            NSString* filePath = [LTxCoreFileManager cacheFilePathWithName:url.lastPathComponent];
            _filePath = [NSURL fileURLWithPath:filePath];
            [self setupPreviewViewContent];
        }
    }
    
}

#pragma mark - 网页
/*释放网页访问资源*/
- (void)dellocWebView{
    if(_webView){
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [_webView removeObserver:self forKeyPath:@"title"];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    self.errorTips = @"无法加载！";
    self.emptyScrollView = self.webView.scrollView;
}

#pragma mark - 视频播放
/*视频播放进度*/
-(void)observeAVPlayerProgress{
    __weak __typeof(self) weakSelf = self;
    _avPlayerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        NSInteger currentTimeSec = time.value / time.timescale;
        weakSelf.playerSlider.value = currentTimeSec;
        CMTime totalTime = weakSelf.player.currentItem.duration;
        NSInteger totalTimeSec = CMTimeGetSeconds(totalTime);
        weakSelf.playerSlider.maximumValue = totalTimeSec;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.playerSlider.timeL.text =[NSString stringWithFormat:@"%@/%@",[weakSelf descriptionWithSeconds:currentTimeSec],[weakSelf descriptionWithSeconds:totalTimeSec]];
        });
    }];
}
/*手势控制进度*/
- (void)handleAVPlayerGesture:(UIGestureRecognizer *)ges{
    if ([ges.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)ges.view;
        CGPoint point = [ges locationInView:slider];
        CGFloat length = slider.frame.size.width - LTxCoreFilePreviewSliderTimeWidth - LTxCoreFilePreviewSliderBtnWidth;
        // 视频跳转的value
        CGFloat tapValue = (point.x - LTxCoreFilePreviewSliderBtnWidth) / length * slider.maximumValue;
        [self.player seekToTime:CMTimeMake(tapValue, 1)];
    }
}

/*续播*/
- (void)playFinished{
    [_player seekToTime:kCMTimeZero];
    [_player play];
}

- (void)play{
    [_player play];
}

- (void)pause{
    [_player pause];
}
/*释放视频播放相关资源*/
- (void)dellocAVPlayer{
    if (_avPlayerObserver) {
        [self.player removeTimeObserver:_avPlayerObserver];
        _avPlayerObserver = nil;
    }
    [_player removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_player pause];
    _player = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return _filePath;
}

#pragma mark - 三方应用分享
-(void)openWithOtherApp{
    if(!_filePath){
        return;
    }
    if ([_filePath.absoluteString hasPrefix:@"http"]) {
        return;
    }
    _docInteractionController = [UIDocumentInteractionController  interactionControllerWithURL:_filePath];
    [_docInteractionController presentOpenInMenuFromRect:self.shareBtn.frame inView:self.view animated:YES];
}

#pragma mark - 监听
/*监听*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == self.player) {//视频播放器
        if ([keyPath isEqualToString:@"status"]) {
            if (_player.status == AVPlayerStatusReadyToPlay) {
                [self play];
            }else{
                
            }
        }
    }else if (object == self.webView){//网页
        if ([keyPath isEqualToString:@"title"]){
            if (!self.title) {
                self.title = self.webView.title;
            }
        }else if ([keyPath isEqualToString:@"estimatedProgress"]) {
            CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (newprogress == 1) {
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            }else {
                self.progressView.hidden = NO;
                [self.progressView setProgress:newprogress animated:YES];
            }
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 进度条
/*进度条*/
-(void)setupProgressView{
    if(_progressView){
        [_progressView removeFromSuperview];
    }
    CGFloat progressBarHeight = 5.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect progressFrame = CGRectMake(0, navigaitonBarBounds.size.height , navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[UIProgressView alloc] initWithFrame:progressFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.trackTintColor = [UIColor whiteColor];
    _progressView.progressTintColor = [[LTxCoreConfig sharedInstance].skinColor colorWithAlphaComponent:0.8];
    [self.navigationController.navigationBar addSubview:_progressView];
}

#pragma mark - Private
/**
 * 时间描述
 **/
-(NSString*)descriptionWithSeconds:(NSInteger)seconds{
    NSString* retString = [NSString stringWithFormat:@"%02ld:%02ld",seconds / LT_DATE_MINUTE,seconds % LT_DATE_MINUTE];
    return retString;
}

/**
 * 约束
 ***/
-(void)addConstraintOnView:(UIView*)contentView{
    NSLayoutConstraint* cLeading = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint* cTrailing = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
    NSLayoutConstraint* cTop = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.f constant:0];
    NSLayoutConstraint* cBottom = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.f constant:0];
    //激活
    [NSLayoutConstraint activateConstraints: @[cLeading,cTrailing,cTop,cBottom]];
}

/**
 * 视频进度条约束
 ***/
-(void)addAVPlayerSliderConstraint{
    NSLayoutConstraint* cLeading = [NSLayoutConstraint constraintWithItem:_playerSlider attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint* cTrailing = [NSLayoutConstraint constraintWithItem:_playerSlider attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
    NSLayoutConstraint* cBottom = [NSLayoutConstraint constraintWithItem:_playerSlider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.f constant:0];
    NSLayoutConstraint* height = [NSLayoutConstraint constraintWithItem:_playerSlider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:40];
    //激活
    [NSLayoutConstraint activateConstraints: @[cLeading,cTrailing,cBottom,height]];
}
@end
