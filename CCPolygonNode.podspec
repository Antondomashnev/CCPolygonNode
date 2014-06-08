Pod::Spec.new do |s|
  s.name         = "CCPolygonNode"
  s.version      = "1.0.0"
  s.summary      = "CCNode subclass to draw polygon with texture (adopt PRKit to cocos2d v3)."
  s.description  = <<-DESC
                    ACCNode subclass to draw polygon with texture (adopt PRKit to cocos2d v3).
                   DESC
  s.homepage     = "https://github.com/Antondomashnev"
  s.author       = { 'Anton Domashnev' => 'antondomashnev@gmail.com' }
  s.source       = { :git => "https://github.com/Antondomashnev/CCPolygonNode.git", :tag => s.version.to_s}
  s.platform = :ios, '5.0'
  s.ios.deployment_target = '6.0'
  s.source_files = '*.{h,m,mm}'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.requires_arc = true
end