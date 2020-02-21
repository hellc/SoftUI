Pod::Spec.new do |s|

  s.name                   = 'SoftUI'
  s.version                = '0.0.1'
  s.summary                = 'Neumorphism design pattern implementation for macOS/iOS/watchOS/tvOS'
  s.homepage               = 'https://github.com/hellc/SoftUI'
  s.license                = 'MIT'
  s.author                 = { 'Ivan Manov' => 'ivanmanov@live.com' }
  s.social_media_url       = 'https://twitter.com/ihellc'

  s.requires_arc           = false
  s.ios.deployment_target  = '11.0'
  s.tvos.deployment_target = '11.0'
  s.osx.deployment_target  = '10.15'

  s.source                 = { :git => 'https://github.com/hellc/SoftUI.git', :tag => s.version }

  s.default_subspec        = 'Core'
  
  s.subspec 'Core' do |c|
    c.source_files         = 'Framework/SoftUI/Core/**/*.swift'
  end
  
end
