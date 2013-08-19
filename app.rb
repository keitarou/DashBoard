require "sinatra"
require "haml"
require "garb"
require "./db/dashboard.rb"
require './config/analytics.rb'

# BASIC認証
use Rack::Auth::Basic do |username, password|
	username == ANALYTICS_USERNAME && password == ANALYTICS_PASSWORD
end


#== Googleアナリティクスの認証
Garb::Session.login ANALYTICS_USERNAME, ANALYTICS_PASSWORD
profile = Garb::Management::Profile.all.detect do |p|
  p.web_property_id == ANALYTICS_CODE
end

class Myreport
  extend Garb::Model
  metrics :pageviews, :visits
  dimensions :date
end



#= アクション
#== TOPページ
get '/' do
  @links = Link.all
  @results = profile.myreport(start_date: Date.today-1, end_date: Date.today)
  haml :index
end

#== 追加処理
post '/create' do

  # 新しいリンクの作成
  link = Link.new
  link.name = params[:name]
  link.url  = params[:url]
  if !link.save then
    @error = true
  end

  @links = Link.all
  @results = profile.myreport(start_date: Date.today-1, end_date: Date.today)
  haml :index
end

#== 削除処理
get '/delete' do

  link = Link.find(params[:id])
  link.destroy

  @links = Link.all
  @results = profile.myreport(start_date: Date.today-1, end_date: Date.today)
  haml :index
end
