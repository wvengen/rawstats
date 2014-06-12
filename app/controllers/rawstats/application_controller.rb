module Rawstats
  class ApplicationController < ActionController::Base


    protected

    # validate requested view
    def rawstats_get_view
      @type = 'web' # @todo
      # @todo config default view
      @view = Rawstats.views(@type).include?(params[:view]) ? params[:view] : 'thismonth.all'
    end

    def rawstats_read_stats
      @config = 'demo' # @todo
      @stats = Rawstats::AwstatsFile.new(path: File.expand_path('../../../../data', __FILE__), stat: @config, year: params[:year], month: params[:month])
    end

    # emit dynamic javascript variables
    def rawstats_js_vars
      content_for :javascript, (
        view_context.javascript_include_tag("rawstats/jawstats_#{@type}") +
        view_context.javascript_include_tag("rawstats/rawstats_monkeys") +
        view_context.javascript_tag("$.extend(window, #{{
          g_sConfig: @config,
          g_sParts: [],           # @todo support parts
          g_iYear: params[:year],
          g_iMonth: params[:month],
          g_sCurrentView: @view,
          g_dLastUpdate: @stats.dtLastUpdate,
          g_iFadeSpeed: 250,      # @todo site config +fadespeed+
          g_bUseStaticXML: false, # @todo support static xml (low-prio)
          g_sLanguage: 'en-gb',   # @todo support multiple languages + config
          sThemeDir: 'default',   # @todo site config +theme+
          sUpdateFilename: nil,   # @todo
          oSubMenu: Rawstats.menu(@type),
          sAppPath: view_context.root_path,
        }.to_json});")
      ).html_safe
    end

  end
end
