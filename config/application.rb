# frozen_string_literal: true
require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mylan
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # time zone from settings
    config.time_zone = ENV["TIME_ZONE"] if ENV["TIME_ZONE"].present?

    # set our subpath, if any
    config.relative_url_root = ENV["RAILS_RELATIVE_URL_ROOT"]

    # SMTP_ADDRESS acts as "email enabled" toggle
    config.action_mailer.perform_deliveries = ENV["SMTP_ADDRESS"].present?

    # map SMTP_xxx envs to smtp_settings
    smtp_conf = {}
    ENV.select { |k, _| k.start_with?("SMTP_") }.map { |k, v| [k[5..-1].downcase, v] }.to_h.each do |key, value|
      key = key.to_sym
      value = case key
      when :port, :open_timeout, :read_timeout
        value.present? ? value.to_i : nil
      when :authentication, :openssl_verify_mode
        value.present? ? value.to_sym : nil
      else
        value
      end
      smtp_conf[key] = value unless value.nil?
    end
    config.action_mailer.smtp_settings = smtp_conf unless smtp_conf.empty?
  end
end
