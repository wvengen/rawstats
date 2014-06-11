require 'jquery-rails'
require 'flot-rails'
require 'jquery-tablesorter'
require 'content_for_in_controllers'

module Rawstats
  class Engine < ::Rails::Engine
    isolate_namespace Rawstats

    initializer "rawstats.assets.precompile" do |app|
      app.config.assets.precompile << "rawstats/rawstats_monkeys.js" # needs to be loaded last
      Rawstats::TYPES.each do |type|
        app.config.assets.precompile << "rawstats/jawstats_#{type}.js"
      end
    end
  end
end
