module Rawstats
  class AwstatsFile

    # Filename patterns to check, specific/probable first
    # @todo (Globally) cache used format to avoid +stat()+ calls
    FILENAME_PATTERNS = [
      'awstats%02<month>d%04<year>d.%<stat>s.txt.utf8',
      'awstats%02<month>d%04<year>d.%<stat>s.txt',
      'awstats%02<month>d%02<year>d.%<stat>s.txt.utf8',
      'awstats%02<month>d%02<year>d.%<stat>s.txt',
    ]

    # Symbolic column indices for section
    COLUMN_INDICES = {
      BROWSER:                   %w(id hits),
      DAY:                       %w(date pages hits bw visits),
      DOMAIN:                    %w(id pages hits bw),
      ERRORS:                    %w(id hits bw),
      FILETYPES:                 %w(id hits bw noncompressedbw compressedbw),
      KEYWORDS:                  %w(word freq),
      OS:                        %w(id hits),
      PAGEREFS:                  %w(url pages hits),
      ROBOT:                     %w(id hits bw lastvisit robotstxt),
      SEARCHWORDS:               %w(search freq),
      SEARCHREFERRALS:           %w(id pages hits),
      SESSION:                   %w(range freq),
      SIDER:                     %w(url pages bw entry exit),
      SIDER_404:                 %w(url hits referer),
      TIME:                      %w(hour pages hits bw notviewedpages notviewedhits notviewedbw),
      VISITOR:                   %w(address pages hits bw lastvisit lastvisitstart lastvisitpage desc),
      EMAILSENDER:               %w(address emails bw lastvisit),
      EMAILRECEIVER:             %w(address emails bw lastvisit),
      PLUGIN_geoip_city_maxmind: %w(id pages hits bw lastvisit),
      PLUGIN_geoip_org_maxmind:  %w(id pages hits bw lastvisit),
    }

    attr_reader :dtLastUpdate, :dtLastTime, :iTotalVisits, :iTotalUnique, :iDailyVisitAvg, :iDailyUniqueAvg

    # @option options [String] :stat AWStats configuration identifier.
    # @option options [String, Path, File] :path Directory where to look for AWStats file.
    # @option options [String] :filename AWStats file to load, or +nil+ to deduct from other parameters.
    # @option options [Number] :year
    # @option options [Number] :month
    # @return [AwstatsFile] New AWStats file object.
    def initialize(options={})
      @filename = self.class.find(options) or return
      parse(@filename)
      @dtLastUpdate = DateTime.parse(get(:general, 'LastUpdate', 1))
      @dtLastTime = DateTime.parse(get(:general, 'LastTime', 1))
      @iTotalVisits = get(:general, 'TotalVisits', 1).to_i
      @iTotalUnique = get(:general, 'TotalUnique', 1).to_i
      @iDaysInMonth = ([@dtLastTime.end_of_month, @dtLastUpdate].min.to_date - @dtLastTime.beginning_of_month.to_date).to_i
      @iDailyVisitAvg = @iTotalVisits / @iDaysInMonth;
      @iDailyUniqueAvg = @iTotalUnique / @iDaysInMonth;
    end

    # @param section [Symbol] Section identifier
    # @param key [String] Match first column
    # @param index [Number, Symbol] Row number or identifier, or +nil+ to return array of columns.
    # @return [String, Array<String>] Value, or array of values on this line.
    def get(section, key=nil, index=nil)
      sdata = get_all(section)
      line = sdata[sdata.index {|a| a[0] == key.to_s}]
      index = COLUMN_INDICES[section.to_sym].index(index.to_s) if index.is_a? Symbol
      index ? line[index] : line
    end

    # @param section [Symbol] Section identifier
    # @return [Array<Array<String>>] Section contents
    def get_all(section)
      section = section.to_s.upcase
      @data[section]
    end

    # @param section [Symbol] Section identifier
    # @return [Array<Hash<Symbol, String>>] Section contents
    def get_all_hash(section)
      get_all(section).map do |line|
        Hash[[*COLUMN_INDICES[section.to_sym.upcase].zip(line)]]
      end
    end


    protected

    # @see #load
    def self.find(options = {})
      # find AWStats file
      filename = options[:filename]
      path = options[:path]
      if filename
        filename = File.join(path, filename) if path
      else
        for pat in FILENAME_PATTERNS do
          filename = pat%options
          filename = File.join(path, filename) if path
          Rails.logger.debug "Testing AWStats file #{filename}"
          break if File.exist?(filename)
        end
      end
      filename if File.exist?(filename)
    end

    # @param data [String] Load data
    def parse(filename)
      Rails.logger.debug "Reading AWStats file #{filename}"
      @data = {}
      section = nil
      IO.readlines(filename).each do |line|
        line.gsub! /#.*$/, ''
        case line
        when /^BEGIN_MAP\b/ then next
        when /^BEGIN_([_A-Z]+)\b/ then section=$1; @data[section] = [];
        when /^END_([_A-Z]+)\b/ then section = nil
        else
          @data[section] << line.split if section
        end
      end
      self
    end

  end
end
