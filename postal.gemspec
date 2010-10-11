# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{postal}
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["The Active Network"]
  s.date = %q{2010-01-29}
  s.description = %q{Lyris is an enterprise email service. Postal makes it easy for Ruby to talk to Lyris's API.}
  s.email = %q{rob.cameron@active.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/postal.rb",
     "lib/postal/base.rb",
     "lib/postal/content.rb",
     "lib/postal/list.rb",
     "lib/postal/lmapi/lmapi.rb",
     "lib/postal/lmapi/lmapi_driver.rb",
     "lib/postal/lmapi/lmapi_mapping_registry.rb",
     "lib/postal/mailing.rb",
     "lib/postal/member.rb",
     "postal.gemspec",
     "test/content_test.rb",
     "test/list_test.rb",
     "test/lmapiClient.rb",
     "test/lyris_sample.yml",
     "test/mailing_test.rb",
     "test/member_test.rb",
     "test/postal_suite.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/activenetwork/postal}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Gem for talking to the Lyris API}
  s.test_files = [
    "test/content_test.rb",
     "test/list_test.rb",
     "test/lmapiClient.rb",
     "test/mailing_test.rb",
     "test/member_test.rb",
     "test/postal_suite.rb",
     "test/test_helper.rb"
  ]

end
