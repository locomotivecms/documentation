# This file is used by Rack-based servers to start the application.

require 'locomotive/builder/standalone_server'

run Locomotive::Builder::StandaloneServer.new(File.expand_path('.'))

# $:.unshift(File.expand_path(File.dirname(__FILE__) + '/lib'))

# require 'bundler'
# Bundler.setup

# require 'locomotive/builder/version'
# require 'locomotive/builder/exceptions'
# require 'locomotive/mounter'

# # set the working path
# path = File.expand_path('.')

# # setting the logger
# logfile = File.join(path, 'log', 'mounter.log')
# FileUtils.mkdir_p(File.dirname(logfile))

# Locomotive::Mounter.logger = ::Logger.new(logfile).tap do |log|
#   log.level = Logger::DEBUG
# end

# # get the reader
# reader = Locomotive::Mounter::Reader::FileSystem.instance
# reader.run!(path: path)
# reader

# # run the rack app
# Bundler.require 'misc'

# require 'locomotive/builder/server'
# run Locomotive::Builder::Server.new(reader, disable_listen: true)

