Pod::Spec.new do |spec|
  spec.name          = 'incetro-observer-list'
  spec.module_name   = 'ObserverList'
  spec.version       = '1.0.0'
  spec.license       = 'MIT'
  spec.authors       = { 'incetro' => 'incetro@ya.ru' }
  spec.homepage      = "https://github.com/Incetro/observer-list.git"
  spec.summary       = 'A simple class that allows us to have a list of weak observers'
  spec.platform      = :ios, "12.0"
  spec.swift_version = '5.3'
  spec.source        = { git: "https://github.com/Incetro/observer-list.git", tag: "#{spec.version}" }
  spec.source_files  = "Sources/ObserverList/**/*.{h,swift}"
end