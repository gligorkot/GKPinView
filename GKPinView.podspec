Pod::Spec.new do |s|

  s.name                  = 'GKPinView'
  s.version               = '0.9.10'
  s.summary               = 'A lock screen Pin/Passcode View for iPhone and iPad.'
  s.description           = <<-DESC
                            * A customisable Pin/Passcode View for iPhone or iPad
                            * It includes a handy delegate to deal with correct/incorrect Pin/Passcode situations.
                              DESC
  s.homepage              = 'https://github.com/gligorkot/GKPinView'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author                = { 'Gligor Kotushevski' => 'gligorkot@gmail.com' }
  s.social_media_url      = 'https://twitter.com/gligor_nz'
  s.platform              = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source                = { :git => 'https://github.com/gligorkot/GKPinView.git', :tag => s.version.to_s }

  s.source_files          = 'Classes', 'Classes/*.{swift}'
  s.resources             = 'Resources/*.{xib}'
  s.pod_target_xcconfig   = { 'SWIFT_VERSION' => '5' }

  s.frameworks            = 'UIKit'
  s.requires_arc          = true

end
