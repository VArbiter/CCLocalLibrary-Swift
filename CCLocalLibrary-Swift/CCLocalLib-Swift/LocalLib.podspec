
Pod::Spec.new do |s|

  s.name         = "LocalLib"
  s.version      = "0.6.4"
  s.summary      = "LocalLib written in swift 3.1"

  s.description  = <<-DESC
            Some categories for Foundation and UIKit .
                   DESC

  s.homepage     = "https://github.com/VArbiter/CCLocalLibrary-Swift"

  s.license      = "MIT"

  s.author             = { "冯明庆" => "elwinfrederick@163.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "LocalLib", :tag => "#{s.version}" }


  s.source_files  = "LocalLib", "LocalLib/**/*"
  # s.exclude_files = "Classes/Exclude"

  s.frameworks = "CoreGraphics", "Foundation" ,"ImageIO" , "MobileCoreServices", "QuartzCore", "Security" , "SystemConfiguration" , "CoreTelephony" , "Photos" , "AssetsLibrary"

  s.requires_arc = true

  s.dependency "MJRefresh", "~> 3.1.12"
  s.dependency "MBProgressHUD", "~> 1.0.0"
  s.dependency "Alamofire", "~> 4.5.0"
  s.dependency "AlamofireNetworkActivityIndicator", "~> 2.2.0"
  s.dependency "Kingfisher", "~> 3.10.2"

end
