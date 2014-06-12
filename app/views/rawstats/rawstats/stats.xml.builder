xml.instruct!
xml.jawstats do
  xml.info lastupdate: @stats.dtLastUpdate.to_i
  xml.data do
    @stats.get_all_hash(params[:section]).map do |line|
      xml.item line
    end
  end
end

