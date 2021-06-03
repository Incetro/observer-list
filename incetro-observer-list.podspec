Pod::Spec.new do |spec|

  spec.name          = 'incetro-observer-list'
  spec.module_name   = 'ObserverList'
  spec.version       = '1.0.1'
  spec.license       = 'MIT'
  spec.authors       = { 'incetro' => 'incetro@ya.ru' }
  spec.homepage      = "https://github.com/Incetro/observer-list.git"
  spec.summary       = 'A simple class that allows us to have a list of weak observers'

  spec.ios.deployment_target     = "12.0"
  spec.osx.deployment_target     = "10.12"
  spec.watchos.deployment_target = "3.1"
  spec.tvos.deployment_target    = "12.0"

  spec.swift_version = '5.3'
  spec.source        = { git: "https://github.com/Incetro/observer-list.git", tag: "#{spec.version}" }
  spec.source_files  = "Sources/ObserverList/**/*.{h,swift}"

end