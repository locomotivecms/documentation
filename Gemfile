source 'https://rubygems.org'

ruby '1.9.3'

group :development do
  gem 'rb-fsevent', '~> 0.9.1', :require => RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
end

# gem 'locomotivecms_mounter', path: '/Users/didier/Documents/LocomotiveCMS/gems/mounter'
# gem 'locomotivecms_builder', path: '/Users/didier/Documents/LocomotiveCMS/builder'

gem 'locomotivecms_mounter', git: 'git://github.com/locomotivecms/mounter.git' #, ref: '5120a3f'
gem 'locomotivecms_builder', git: 'git://github.com/locomotivecms/builder.git', branch: 'wip' #, ref: '5120a3f'

group :misc do
  gem 'susy', require: 'susy'
  gem 'redcarpet', require: 'redcarpet'
end