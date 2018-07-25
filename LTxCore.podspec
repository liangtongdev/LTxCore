Pod::Spec.new do |s|
  s.name         = "LTxCore"
  s.version      = "0.5.0"
  s.summary      = "组件化管理核心模块. "
  s.license      = "MIT"
  s.author             = { "liangtong" => "liangtongdev@163.com" }

  s.homepage     = "https://github.com/liangtongdev/LTxCore"
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/liangtongdev/LTxCore.git", :tag => "#{s.version}", :submodules => true }

  s.dependency 'MJRefresh', '~> 3.1.15.3'
  s.dependency 'DZNEmptyDataSet', '~> 1.8.1'
  s.dependency 'AFNetworking', '~> 3.2.1'
  s.dependency 'Toast', '~> 4.0.0'
  s.dependency 'FMDB', '~> 2.7.2'
  s.dependency 'SSZipArchive', '~> 2.1.3'
  s.frameworks = "Foundation", "UIKit"

  #  s.default_subspecs = 'Controllers'



  # Model
  s.subspec 'Model' do |sp|
    sp.source_files  =  "LTxCore/Model/*.{h,m}"
    sp.public_header_files = "LTxCore/Model/**/*.h"
  end

  # Utils
  s.subspec 'Utils' do |sp|
    sp.source_files  =  "LTxCore/Utils/*.{h,m}"
    sp.public_header_files = "LTxCore/Utils/**/*.h"
    sp.dependency 'LTxCore/Model'
  end

  # Views
  s.subspec 'Views' do |sp|
    sp.source_files  =  "LTxCore/Views/*.{h,m}"
    sp.public_header_files = "LTxCore/Views/**/*.h"
    sp.dependency 'LTxCore/Utils'
  end

  # Controllers
  s.subspec 'Controllers' do |sp|
    sp.source_files  =  "LTxCore/Controllers/*.{h,m}"
    sp.public_header_files = "LTxCore/Controllers/**/*.h"
    sp.dependency 'LTxCore/Views'
  end

  # Core
  s.subspec 'Core' do |sp|
    sp.public_header_files = 'LTxCore/LTxCore.h'
    sp.source_files = 'LTxCore/LTxCore.h'
    sp.dependency 'LTxCore/Controllers'
  end

end
