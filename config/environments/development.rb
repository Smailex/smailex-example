SmailexExample::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  #Smailex credentials and API url
  SmailexClientID = "dfa823127bd048e537ee9bec3dc2eb75519cc559ee95825a65436c2adb7f4f5d"
  SmailexClientSecret = "e19601aa96347c17a4aea13b7e09c7cbc5714d6f50dab84f79a266af20c80776"
  SmailexStageAPIUrl = "https://localhost:3000/api/v1"
  SmailexUsername = "roman.sotnikov@gmail.com"
  SmailexPassword = "password"
end
