source 'https://github.com/CocoaPods/Specs.git'

target 'TrueColors' do
  platform :osx, "10.9"

  pod 'BFColorPickerPopover',
    :git => 'https://github.com/DrummerB/BFColorPickerPopover.git'
  pod 'CyndiLauper',
    :path => '.'
  pod 'DCOAboutWindow', '~> 0.2'
  pod 'HockeySDK-Mac'
  pod 'ILGHttpConstants', '~> 1.0'
  pod 'MAKVONotificationCenter', '~> 0.0'
  pod 'MASPreferences',
    :git => 'https://github.com/shpakovski/MASPreferences.git',
    :tag => '1.2'
  pod 'Sparkle', '~> 1.14.0'
  pod 'UICKeyChainStore', '~> 2.0'
  pod 'xUnique'

  target 'TrueColorsTests' do
    inherit! :search_paths
  end
end

post_install do | installer |
  # Use the GitHub API to render CocoaPods's Pods-acknowledgements.markdown file as HTML.
  system(%Q(
            curl "https://api.github.com/markdown/raw" \
            --silent \
            --request "POST" \
            --header "Content-Type:text/x-markdown" \
            --data-binary @"Pods/Target Support Files/Pods-TrueColors/Pods-TrueColors-acknowledgements.markdown" \
            --output "TrueColors/Resources/Acknowledgements.html"
         ))
end
