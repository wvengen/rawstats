require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Rawstats
  class DummyGenerator < Rails::Generators::Base
    desc "Creates blank Rails application, installs Rawstats, and all sample data"

    def self.source_paths
      paths = self.superclass.source_paths
      paths << File.expand_path('../templates', __FILE__)
      paths.flatten
    end

    PASSTHROUGH_OPTIONS = [
      :skip_javascript, :javascript, :quiet, :pretend, :force, :skip
    ]

    def generate_test_dummy
      opts = (options || {}).slice(*PASSTHROUGH_OPTIONS)
      opts[:force] = true
      opts[:skip_bundle] = true
      opts[:old_style_hash] = true

      invoke Rails::Generators::AppGenerator, [ File.expand_path(dummy_path, destination_root) ], opts

      run "rails generate rawstats:install --no-migrate=true"
    end

    def test_dummy_clean
      inside dummy_path do
        remove_file ".gitignore"
        remove_file "doc"
        remove_file "Gemfile"
        remove_file "lib/tasks"
        remove_file "app"
        remove_file "public/index.html"
        remove_file "public/robots.txt"
        remove_file "README"
        remove_file "test"
        remove_file "vendor"
      end
    end

    def test_dummy_config
      directory "app", "#{dummy_path}/app"
      template "config/boot.rb", "#{dummy_path}/config/boot.rb", :force => true
      template "config/application.rb", "#{dummy_path}/config/application.rb", :force => true
      template "config/routes.rb", "#{dummy_path}/config/routes.rb", :force => true
      template "Rakefile", "#{dummy_path}/Rakefile", :force => true
      inject_into_file "#{dummy_path}/config/environments/test.rb",
                  "\n  config.action_mailer.default_url_options = { :host => 'www.example.com' }\n",
                  :before => "end\n",
                  :verbose => false
    end

    protected

      def dummy_path
        'spec/dummy'
      end

      def module_name
        'Dummy'
      end

      def application_definition
        @application_definition ||= begin
          dummy_application_path = File.expand_path("#{dummy_path}/config/application.rb", destination_root)
          unless options[:pretend] || !File.exists?(dummy_application_path)
            contents = File.read(dummy_application_path)
            contents[(contents.index("module #{module_name}"))..-1]
          end
        end
      end
      alias :store_application_definition! :application_definition

      def gemfile_path
        '../../../../Gemfile'
      end
  end
end
