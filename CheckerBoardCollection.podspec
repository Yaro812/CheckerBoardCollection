Pod::Spec.new do |s|
  s.name         = "CheckerBoardCollection"
  s.version      = "0.1.1"
  s.platform     = :ios, '9.0'
  s.summary      = "UICollectionView vertical flow layout"
  s.homepage     = "https://github.com/Yaro812/CheckerBoardCollection.git"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Thorax" => "thorax@me.com" }
  s.source       = { :git => "https://github.com/Yaro812/CheckerBoardCollection.git" }
  s.source_files  = 'Classes', 'Classes/*.{swift}'
  s.requires_arc = true
end
