class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include HTTParty

  before_filter :set_user_time_zone
  before_filter :get_teamspeak_status
  
  def set_user_time_zone
    Time.zone = current_user.time_zone if signed_in?
  end
  
  def get_teamspeak_status
    begin
      url = "http://www.tsviewer.com/ts3viewer.php?ID=#{CLAN_TSVIEW_ID}&text=000000&text_size=12&text_family=1&js=1&text_s_weight=bold&text_s_style=normal&text_s_variant=normal&text_s_decoration=none&text_s_color_h=525284&text_s_weight_h=bold&text_s_style_h=normal&text_s_variant_h=normal&text_s_decoration_h=underline&text_i_weight=normal&text_i_style=normal&text_i_variant=normal&text_i_decoration=none&text_i_color_h=525284&text_i_weight_h=normal&text_i_style_h=normal&text_i_variant_h=normal&text_i_decoration_h=underline&text_c_weight=normal&text_c_style=normal&text_c_variant=normal&text_c_decoration=none&text_c_color_h=525284&text_c_weight_h=normal&text_c_style_h=normal&text_c_variant_h=normal&text_c_decoration_h=underline&text_u_weight=bold&text_u_style=normal&text_u_variant=normal&text_u_decoration=none&text_u_color_h=525284&text_u_weight_h=bold&text_u_style_h=normal&text_u_variant_h=normal&text_u_decoration_h=none"
      response = self.class.get url
      
      raw = response.parsed_response.html_safe
      files = Dir.glob("app/assets/images/ts/*")
      files.each do |file|
        file_name = file.gsub('app/assets/images/ts/', '')
        raw.gsub! "http://static.tsviewer.com/images/teamspeak3/standard/#{file_name}", view_context.image_url("ts/#{file_name}")
      end
      raw.gsub! 'http://static.tsviewer.com//images/teamspeak3/default/tsv20100409.png', view_context.image_url('ts/tsv20100409.png')
          
      @ts_status = raw.html_safe
    rescue
      @ts_status = ""
    end          
  end
end
