#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name     = 'MAConfirmButtoniOS7'
  s.version  = '1.6.3'
  s.summary          = "A cloned verion for MAConfirmButton to be used in iOS7."
  s.description      = <<-DESC
                       MAConfirmButton is an animated subclass of UIButton that replicates and improves upon the behavior of the AppStore “Buy Now” buttons. Built and animated with Core Animation layers, it is completely image free.
                       DESC
  s.homepage         = "https://github.com/lamogura/MAConfirmButtoniOS7"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Ronald Li" => "ronailhk@gmail.com" }
  s.source           = { :git => "https://github.com/lamogura/MAConfirmButtoniOS7.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.subspec 'no-arc' do |sp|
    sp.source_files = 'Pod/Classes/UIColor-Expanded.{h,m}'
    sp.requires_arc = false
  end
  s.source_files = 'Pod/Classes/MAConfirmButton.{h,m}'
  # s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'QuartzCore'
  # s.dependency 'AFNetworking', '~> 2.3'
end
