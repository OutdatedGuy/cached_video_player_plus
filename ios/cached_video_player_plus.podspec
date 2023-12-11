#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint cached_video_player_plus.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'cached_video_player_plus'
  s.version          = '1.0.0'
  s.summary          = 'Caching enabled video_player plugin for Flutter.'
  s.description      = <<-DESC
Original video_player plugin with the superpower of caching embedded in Android and iOS.
                       DESC
  s.homepage         = 'https://outdatedguy.rocks'
  s.license          = { :file => '../LICENSE', :type => 'BSD-3-Clause' }
  s.author           = { 'OutdatedGuy' => 'everythingoutdated@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # KTVHTTPCache
  s.dependency 'KTVHTTPCache', '~> 2.0.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
