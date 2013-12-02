Pod::Spec.new do |s|
  s.name         = "DOTActivityIndicator"
  s.version      = "0.1.0"
  s.summary      = "An acitivity indicator using three dots."
  s.homepage     = "https://github.com/wentingliu/DOTActivityIndicator"
  s.license      = 'WTFPL'
  s.author       = { "Wenting Liu" => "wentingliu@live.com" }
  s.source       = { :git => "https://github.com/wentingliu/DOTActivityIndicator.git", :tag => "0.1.0" }
  s.platform     = :ios, '5.0'
  s.source_files = 'DOTActivityIndicator/**/*.{h,m}'
  s.frameworks   = 'CoreGraphics'
  s.requires_arc = true
end