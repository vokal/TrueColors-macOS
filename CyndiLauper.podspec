#
# Be sure to run `pod lib lint CyndiLauper.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CyndiLauper"
  s.version          = "0.4.0"
  s.summary          = "Library for handling `.truecolors` files"
  s.homepage         = "https://github.com/vokal/TrueColors-macOS"
  s.license          = { :type => 'MIT' }
  s.author           = { "Isaac Greenspan" => "isaac.greenspan@vokal.io" }
  s.source           = { :git => "https://github.com/vokal/TrueColors-macOS.git", :tag => "CyndiLauper/#{s.version.to_s}" }

  s.platform     = :osx, '10.9'
  s.requires_arc = true

  s.source_files   = 'CyndiLauper/**/*.[hm]'
  s.prepare_command = <<-CMD
    cd "CyndiLauper/Models/"
    xcrun momc "CASLSpecs.xcdatamodeld" "${PWD}/CASLSpecs.momd"
    xxd -i "CASLSpecs.momd/CASLSpecs.mom" "CASLSpecsModel.h"
    rm -r "CASLSpecs.momd"
  CMD
  s.compiler_flags = '-Wunused-parameter'
  s.dependency 'zipzap', '8.0.3'
  s.dependency 'Vokoder/Core', '~> 4.0'
  s.dependency 'ILGDynamicObjC/ILGClasses', '~> 0.1.1'
end
