module Rawstats
  module ApplicationHelper

    # @param [String] Image name without extension
    # @return [String] Full asset path of image
    # @todo support multiple themes
    def theme_image_path(img, options = {})
      image_path("rawstats/themes/default/#{img}.gif", options)
    end

    # @return [String] Navigation menu
    def navigation_menu
      content_tag :ul do
        Rawstats.views(@type).map do |id|
          content_tag :li, id: "tab#{id}" do
            menu = Rawstats.menu(@type, id)
            # @todo I18n label
            content_tag :span, menu['label'], onClick: "ChangeTab(this, '#{id}.#{menu['subview'][0]}')".html_safe
          end
        end.join('').html_safe
      end.html_safe
    end

  end
end
