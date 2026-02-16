require 'yaml'

module SettingsHelper
  def settings
    @settings ||= Settings.new
  end
end

class Settings
  attr_reader :settings

  def initialize
    settings_file = File.join(File.dirname(__FILE__), '..', 'config', 'settings.yml')

    @settings = if File.exist?(settings_file)
      YAML.load_file(settings_file)
    else
      {}
    end
  rescue => e
    puts "Warning: Could not load settings from #{settings_file}: #{e.message}"
    {}
  end

  def get(key_path)
    keys = key_path.to_s.split('.')
    value = settings

    keys.each do |key|
      if value.is_a?(Hash) && value.key?(key)
        value = value[key]
      else
        return nil
      end
    end

    value
  end

  def method_missing(method_name, *args, &block)
    if settings.key?(method_name.to_s)
      settings[method_name.to_s]
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    settings.key?(method_name.to_s) || super
  end
end
