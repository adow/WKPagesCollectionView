Pod::Spec.new do |s|
  s.name         = 'WKPagesCollectionView'
  s.version      = '0.1.0'
  s.summary      = 'A collection view that mimics the tab switcher in Safari for iOS 7.'
  s.description  = 'WKPagesCollectionView mimics the transformed list of tabs as seen in Safari for iOS 7. It has support for animating in and out the tabs, as well as adding and deleting tabs.'
  s.homepage     = 'http://EXAMPLE/WKPagesCollectionView'
  s.screenshots  = 'https://camo.githubusercontent.com/1fe6654948c6aa9a68d80c65ba3019344e25e071/687474703a2f2f6661726d342e737461746963666c69636b722e636f6d2f333832392f31313137313833313831345f396335393732626265365f7a2e6a7067'
  s.license      = 'unknown'
  s.author       = { 'adow' => 'reynoldqin@gmail.com' }
  s.platform     = :ios, '7.0'
  s.source       = :git => 'git@github.com:NextFaze/WKPagesCollectionView.git'
  s.source_files = 'WKPagesScrollView/WKPagesCollectionView/*.{h,m}'
  s.frameworks   = 'QuartzCore', 'CoreGraphics'
  s.requires_arc = true
end
