require 'rails/generators'
module Rawstats
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path("../install/templates", __FILE__)
      desc "Used to install Rawstats"

      def add_rawstats_initializer
        path = "#{Rails.root}/config/initializers/rawstats.rb"
        if File.exists?(path)
          puts "Skipping config/initializers/rawstats.rb creation, as file already exists!"
        else
          puts "Adding rawstats initializer (config/initializers/rawstats.rb)..."
          template "initializer.rb", path
          require path # Load the configuration
        end
      end

      def mount_engine
        puts "Mounting Rawstats::Engine at \"/rawstats\" in config/routes.rb..."
        insert_into_file("#{Rails.root}/config/routes.rb", :after => /routes.draw.do\n/) do
          %Q{
  # This line mounts Rawstats's routes at /rawstats by default.
  # This means, any requests to the /rawstats URL of your application will go to Rawstats::RawstatsController#index.
  # If you would like to change where this extension is mounted, simply change the :at option to something different.
  mount Rawstats::Engine, :at => '/rawstats'

}
        end
      end

      def create_assets
        create_file Rails.root + "vendor/assets/stylesheets/rawstats.css.scss"
        create_file Rails.root + "vendor/assets/javascripts/rawstats.js" do
          %Q{
#= require jquery
#= require jquery.json
#= require jquery-tablesorter
#= require jquery.flot
#= require jquery.flot.pie
#= require jquery.flot.stack
          }
        end
      end

      def finished
        output = "\n\n" + ("*" * 53)
        output += %Q{\nDone! Rawstats has been successfully installed.

Here's what happened:\n\n}

        output += step("A new file was created at config/initializers/rawstats.rb
   This is where you put Rawstats's configuration settings.\n")
        output += step("The engine was mounted in your config/routes.rb file using this line:

   mount Rawstats::Engine, :at => \"/rawstats\"

   If you want to change where the statistics are located, just change the \"/rawstats\" path at the end of this line to whatever you want.")
        output += "\nIf you have any questions, comments or issues, please post them on our issues page: http://github.com/radar/rawstats/issues.\n\n"
        output += "Thanks for using Rawstats!"
        puts output
      end

      private

      def step(words)
        @step ||= 0
        @step += 1
        "#{@step}) #{words}\n"
      end

    end
  end
end
