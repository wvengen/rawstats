namespace :rawstats do
  desc "Generates a dummy app for testing"
  task :dummy_app => [:setup_dummy_app]

  task :setup_dummy_app do
    require 'rails'
    require 'rawstats'
    require File.expand_path('../../generators/rawstats/dummy/dummy_generator', __FILE__)

    Rawstats::DummyGenerator.start %w(--quiet)
  end

  desc "Destroy dummy app"
  task :destroy_dummy_app do
    FileUtils.rm_rf "spec/dummy" if File.exists?("spec/dummy")
  end
end
