Pod::Spec.new do |s|  
  s.name         = 'MXNavigationBarManager'
  s.version      = '1.2'
  s.summary      = 'The easy way to change you navigationBar'
  s.homepage     = 'https://github.com/cwxatlm/MXNavigationBarManager'
  s.license      = 'MIT'
  s.authors      = {'wx chen' => '524200634@qq.com'}
  s.platform     = :ios, '7.0'
  s.source       = {:git => 'https://github.com/cwxatlm/MXNavigationBarManager.git', :tag => s.version}
  s.source_files = 'MXNavigationBarManager/**/*.{h,m}'
  s.requires_arc = true
end 
