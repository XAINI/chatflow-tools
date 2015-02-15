class ProduceController < ApplicationController

  before_filter :pre_load

  def pre_load
  end

  def index
    

    # render :nothing => true
  end


  def convert

    pre_path = Rails.root.to_s + '/public/pre.yml'
    chat_text = params[:chat_text].strip
    case params[:type]
    when 'qq'
      @data = convert_qq(chat_text, pre_path)
    else
      @data = convert_webchat(chat_text, pre_path)
    end
    

    render :index
    # render :nothing => true

  end


  private
    def convert_webchat(str, pre_path)

      str = str.gsub(/\d{2}\:\d{2}/, '').gsub(/\*/, '').gsub(/\n/,'').gsub(/@/, '').gsub(/:/, '').gsub(/\r/, '')
      items = str.scan(/\[(.*?)\]([^\[]*)/)


      data = {}
      data['scripts'] = []
      items.each_with_index do |item, index|

        yml_file = YAML::load_file(pre_path)

        item[1] = item[1].gsub(/^#{item[0]}/, '')
        yml_file['scripts'][0]['npc'] = item[0]
        yml_file['scripts'][0]['sentences'][0]['text'] = item[1]

        data['scripts'] << yml_file['scripts'][0]

        
      end

      data
    end


    def convert_qq(str, pre_path)
      pattern = /^[\u4E00-\u9FA5\w]+[\s][\d{4}\/\d{1,2}\/\d{1,2} \d{2}:\d{2}:\d{2}]{1,}\s+$/
      items = str.scan(pattern)
      values = str.split(pattern).delete_if(&:blank?)

      data = {}
      data['scripts'] = []
      items.each_with_index do |item, index|

        yml_file = YAML::load_file(pre_path)

        yml_file['scripts'][0]['npc'] = items[index].gsub(/\d{4}\/\d{1,2}\/\d{1,2} \d{2}:\d{2}:\d{2}/, '').strip

        value = values[index].gsub(/\r\n/,'').gsub(/@/, '').gsub(/:/, '').gsub(/\r/, '')
        yml_file['scripts'][0]['sentences'][0]['text'] = value

        data['scripts'] << yml_file['scripts'][0]

        
      end

      data
    end





end