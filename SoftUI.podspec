Pod::Spec.new do |s|

  s.swift_versions         = '5.0'
  s.name                   = 'SoftUI'
  s.version                = '0.0.4'
  s.summary                = 'Neumorphism design pattern implementation for macOS/iOS/watchOS/tvOS'
  s.homepage               = 'https://github.com/hellc/SoftUI'
  s.license                = 'MIT'
  s.author                 = { 'Ivan Manov' => 'ivanmanov@live.com' }
  s.social_media_url       = 'https://twitter.com/ihellc'

  s.requires_arc           = false
  s.ios.deployment_target  = '11.0'
  
  s.resources = "Framework/SoftUI/**/*.xib"
  s.resource_bundles = {
   'SoftUI' => [
       'Framework/SoftUI/**/*.xib'
   ]
  }

  s.source                 = { :git => 'https://github.com/hellc/SoftUI.git', :tag => s.version }

  s.default_subspec        = 'All'
  
  s.subspec 'All' do |all|
    all.dependency           'SoftUI/Core'
    all.dependency           'SoftUI/Buttons'
    all.dependency           'SoftUI/Cards'
  end
  
  s.subspec 'Core' do |core|
    core.source_files      = 'Framework/SoftUI/Core/**/*.swift'
  end
  
  s.subspec 'Buttons' do |buttons|
    buttons.dependency       'SoftUI/Core'
    buttons.source_files   = 'Framework/SoftUI/Controls/Buttons/*.swift'
  end
  
  s.subspec 'Cards' do |cards|
    cards.dependency       'SoftUI/Core'
    cards.source_files   = 'Framework/SoftUI/Controls/Cards/**/*.{swift}'
  end

end
