
Pod::Spec.new do |s|

  s.name         = "NGCardKit"
  s.version      = "1.0.0"
  s.summary      = "scrollable cards UI"
  s.homepage     = "https://github.com/nimrodgat/NGCardKit"
  s.license      = "MIT"
  s.author       = "Nim Gat"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/nimrodgat/NGCardKit.git", :tag => "#{s.version}" }
  s.source_files = "NGCardKit", "NGCardKit/**/*.{h,m}"
end
