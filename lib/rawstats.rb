require "rawstats/engine"
require "rawstats/awstats_file"

module Rawstats

  # Types of statistics
  #
  # Each type needs:
  # * a menu definition in +config/ui/<type>menu.xml+
  # * a javascript file in +app/assets/javascripts/rawstats/jawstats_<type>.js+
  TYPES = ['web', 'mail']

  # @param type [String] One of {TYPES}
  # @param tab [String] Tab, or +nil+ for complete menu
  # @param subview [String] Subview, or +nil+ for complete tab
  # @return [Hash] Menu structure from +config/ui+
  def self.menu(type, tab=nil, subview=nil)
    @@menus ||= Hash[[ *TYPES.map do |type|
      # @todo find xml file in Rails search path
      [type, Hash.from_xml(File.read(File.expand_path("../../config/ui/#{type}menu.xml", __FILE__)))]
    end ]]
    r = @@menus[type]['menu']
    return r if tab.nil?
    r = r['tab'].select {|t| t['id'] == tab.to_s}.first
    r['subview'] = [r['subview']] unless r['subview'].is_a? Array # allow indexing as array without subviews
    return r if subview.nil?
    r = r['subview'].select {|s| s['id'] == subview.to_s}.first
    return r
  end

  # @param type [String] One of {TYPES}
  # @param tab [String] Tab, or +nil+ to return tabs
  # @return [Array<String>] Identifiers of available views
  def self.views(type, tab=nil)
    r = self.menu(type, tab)
    return r['tab'].map {|t| t['id']}.compact if tab.nil?
    return r['subview'].map {|t| t['id']}.compact
  end

end
