require 'erb'
require 'json'
require 'socket'
require 'sinatra/base'
require 'will_paginate'

class Player
  attr_accessor :name, :clan, :rating, :games

  def self.parse(player_hash)
    res = Player.new
    res.name = player_hash[:name]
    res.clan = player_hash[:clan]
    res.rating = player_hash[:rating]
    res
  end
end

class Clan
  attr_accessor :name, :rating, :players

  def self.parse(clan_hash)
    res = Clan.new
    res.name = clan_hash[:clan_name]
    res.rating = clan_hash[:clan_rating]
    res
  end
end

class Game
  attr_accessor :id, :gametype, :map, :time, :result, :date

  def self.parse(game_hash)
    res = Game.new
    res.id = game_hash[:game_id]
    res.gametype = game_hash[:gametype]
    res.map = game_hash[:map]
    res.time = game_hash[:game_time]
    res.result = game_hash[:game_result]
    res.date = game_hash[:game_date]
    res
  end
end

class TeeworldsRatings < Sinatra::Base
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

  def get_player(name)
    request = {:message_type => "external_message", :message_content =>
     {:external_message_type => "data_request", :external_message_content =>
      {:data_request_type => "player_info", :data_request_content =>
       {:name => name}}}}
    request_json = JSON.generate(request)
    s = TCPSocket.new '127.0.0.1', 12488
    s.puts request_json
    response_json = s.gets
    s.close
    puts response_json
    players_json = JSON.parse(response_json, symbolize_names: true)
    player_games = players_json[:message_content][:external_message_content][:data_request_response_content]
    player = player_games[:player]
    res = Player.parse player
    res.games = player_games[:games].map { |game| Game.parse(game) }
    res
  end

  def get_players(offset, limit)
    request = {:message_type => "external_message", :message_content =>
     {:external_message_type => "data_request", :external_message_content =>
      {:data_request_type => "players_by_rating", :data_request_content =>
       {:limit => limit, :offset => offset}}}}
    request_json = JSON.generate(request)
    s = TCPSocket.new '127.0.0.1', 12488
    s.puts request_json
    response_json = s.gets
    s.close
    players_json = JSON.parse(response_json, symbolize_names: true)
    players = players_json[:message_content][:external_message_content][:data_request_response_content]
    players.map { |p| Player.parse(p) }
  end

  def get_clan(name)
    request = {:message_type => "external_message", :message_content =>
     {:external_message_type => "data_request", :external_message_content =>
      {:data_request_type => "clan_info", :data_request_content =>
       {:name => name}}}}
    request_json = JSON.generate(request)
    s = TCPSocket.new '127.0.0.1', 12488
    s.puts request_json
    response_json = s.gets
    s.close
    clan_json = JSON.parse(response_json, symbolize_names: true)
    clan = clan_json[:message_content][:external_message_content][:data_request_response_content]
    res = Clan.parse(clan[:clan])
    res.players = clan[:players].map { |p| Player.parse p }
    res
  end

  set :haml, :format => :html5

  get '/' do
    #@players = Player.paginate(:page => params[:page], :per_page => 50).
      #order("rating DESC").all
    @players = get_players 0, 50
    haml :index
  end

  get '/players/:player' do |player_name|
    @player = get_player player_name
    haml :player
  end

  get '/clans/:clan' do |clan|
    @clan = get_clan clan
    @players = @clan.players
    haml :clan
  end

  get '/about' do
    haml :about
  end
end
