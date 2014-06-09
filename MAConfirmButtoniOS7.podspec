Pod::Spec.new do |s|
  s.name     = 'MAConfirmButtoniOS7'
  s.version  = '1.6.1'
  s.platform = :ios, '7.0'
  s.summary  = 'A cloned verion for MAConfirmButton to be used in iOS7'
  s.homepage = 'https://github.com/ronail/MAConfirmButton.git'
  s.author   = { 'Ronald Li' => 'ronailhk@gmail.com' }
  s.source   = { :git => 'https://github.com/ronail/MAConfirmButton.git', :tag => s.version.to_s }
  s.license      = { :type => 'New BSD License', :file => 'LICENSE' }
  s.source_files = '*.{h,m}'
  s.requires_arc = false
end
