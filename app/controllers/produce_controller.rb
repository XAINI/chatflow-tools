class ProduceController < ApplicationController

  before_filter :pre_load

  def pre_load
  end

  def index
    

    # render :nothing => true
  end


  def convert
    file_path = Rails.root.to_s + '/public/origin.yml'
    yml_file = YAML::load_file(file_path)

    str = params[:chat_text]

    # p str


    str = str.gsub(/\d{2}\:\d{2}/, '').gsub(/\*/, '').gsub(/\n/,'').gsub(/@/, '').gsub(/:/, '').gsub(/\r/, '')
    items = str.scan(/\[(.*?)\]([^\[]*)/)

    # p items

    items.each_with_index do |item, index|
      # p index
      # p item[0]
      # p item[1]

      item[1] = item[1].gsub(/^#{item[0]}/, '')
      yml_file['scripts'][index]['npc'] = item[0]
      yml_file['scripts'][index]['sentences'][0]['text'] = item[1]

      # @output = yml_file.to_yaml + "\n"

      File.open(file_path, 'w') {|f| f.write yml_file.to_yaml }

    end

    @output = File.read(file_path)


    render :index
    # render :nothing => true


  end





end