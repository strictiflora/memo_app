# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require_relative 'memo_class'

before do
  @memos = Memo.load
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  @memos.generate(title, content)
  redirect to('/memos')
end

get '/memos/:id' do
  id = params[:id].to_i
  @memo = @memos.find_memo_by_id(id)
  if @memo
    erb :detail
  else
    status 404
  end
end

get '/memos/:id/edit' do
  id = params[:id].to_i
  @memo = @memos.find_memo_by_id(id)
  erb :edit
end

patch '/memos/:id/edit' do
  title = params[:title]
  content = params[:content]
  id = params[:id].to_i
  @memos.edit(id, title, content)
  redirect to("/memos/#{id}")
end

delete '/memos/:id' do
  @memos.delete(params[:id])
  redirect to('/memos')
end

not_found do
  erb :notfound, layout: :layout2
end
