require 'erb'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'will_paginate'
require 'will_paginate/active_record'

set :database, {adapter: "sqlite3", database: "rctf.db"}

class Player < ActiveRecord::Base
end

class Clan < ActiveRecord::Base
end

class TeeworldsRatings < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  register WillPaginate::Sinatra

  helpers do
    def encode_url(url)
      ERB::Util.url_encode(url)
    end

    def active_page?(path='')
      request.path_info == path
    end

    def append_class_on_path(tag, attrs, name, path, css_class)
      haml_tag(tag, name, attrs.merge!(class: (css_class if active_page?(path))))
    end

    def link_to_active_page(name, path, css_class='active')
      append_class_on_path :a, {:href => path}, name, path, css_class
    end
  end

  set :haml, :format => :html5

  get '/' do
    @players = Player.paginate(:page => params[:page], :per_page => 50).
      order("rating DESC").all
    haml :index
  end

  get '/players/:player' do |player_name|
    @player = Player.where(name: player_name).first
    haml :player
  end

  get '/clans/:clan' do |clan|
    @players = Player.where(clan: clan).all
    @clan = Clan.where(clan: clan).first
    haml :clan
  end

  get '/about' do
    haml :about
  end
end
