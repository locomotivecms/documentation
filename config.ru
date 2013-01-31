# This file is used by Rack-based servers to start the application.

require 'locomotive/builder/standalone_server'

run Locomotive::Builder::StandaloneServer.new(File.expand_path('.'))