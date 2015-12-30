Pod::Spec.new do |spec|
  spec.name         = 'Majima'
  spec.version      = '0.1.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/soutaro/Majima'
  spec.authors      = { 'Soutaro Matsumoto' => 'matsumoto@soutaro.com' }
  spec.summary      = 'Three-way merge for array and dictionary, in Swift'
  spec.source       = { :git => 'https://github.com/soutaro/Majima.git', :tag => spec.version.to_s }
  spec.source_files = 'Majima/*.swift'
  spec.platform     = :ios, "8.0"
  spec.requires_arc = true
end
