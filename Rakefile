# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.spec 'routicle' do
  developer('Aaron Patterson', 'aaron@tenderlovemaking.com')
  self.readme_file   = 'README.rdoc'
  self.history_file  = 'CHANGELOG.rdoc'
  self.extra_rdoc_files  = FileList['*.rdoc']
end

rule '.rb' => '.rex' do |t|
  sh "rex --independent -o #{t.name} #{t.source}"
end

Rake::Task[:test].prerequisites << "lib/routicle/template/scanner.rb"

# vim: syntax=ruby
