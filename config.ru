map '/' do
  require './app'
  run Sinatra::Application
end

#map '/assets' do
#  require 'sprockets'
#  require 'yui/compressor'
#
#  class MySprocketsEnv < Sprockets::Environment
#    def call(env)
#      @request= Rack::Request.new(env)
#      eval("self.context_class.class_eval do
#        attr_accessor :platform_string
#        def initialize(*args)
#          @platform_string= '#{@request.user_agent}'
#          super
#        end
#      end")
#      self.cache= false
#      super
#    end
#  end
#  env = MySprocketsEnv.new
#  #env = Sprockets::Environment.new
#  env.append_path 'app/javascripts'
#  env.append_path 'app/stylesheets'
#  env.append_path 'app/images'
#  if production?
#    # Compress ALL the assets in production.
#    env.js_compressor = YUI::JavaScriptCompressor.new
#    #env.css_compressor = YUI::CssCompressor.new
#  end
#  run env
#end
