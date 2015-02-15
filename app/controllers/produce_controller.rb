class ProduceController < ApplicationController

  before_filter :pre_load

  def pre_load
  end

  def index
    

    # render :nothing => true
  end


  def convert
    

    target_file = Rails.root.to_s + '/public/target.yml'
    file_path = Rails.root.to_s + '/public/origin.yml'
    yml_file = YAML::load_file(file_path)


    File.open(target_file, 'w') {}

    str = params[:chat_text]


    str = str.gsub(/\d{2}\:\d{2}/, '').gsub(/\*/, '').gsub(/\n/,'').gsub(/@/, '').gsub(/:/, '').gsub(/\r/, '')
    items = str.scan(/\[(.*?)\]([^\[]*)/)


    items.each_with_index do |item, index|
      # p index
      # p item[0]
      # p item[1]

      item[1] = item[1].gsub(/^#{item[0]}/, '')
      yml_file['scripts'][0]['npc'] = item[0]
      yml_file['scripts'][0]['sentences'][0]['text'] = item[1]


      File.open(target_file, 'a') {|f| f.write yml_file.to_yaml }

    end

    @output = File.read(target_file)


    render :index
    # render :nothing => true


  end





end