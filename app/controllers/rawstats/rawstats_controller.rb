module Rawstats
  class RawstatsController < ApplicationController

    before_filter :rawstats_read_stats
    before_filter :rawstats_get_view, :rawstats_js_vars, only: [:show]

  end
end
