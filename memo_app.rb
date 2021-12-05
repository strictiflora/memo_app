# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require_relative 'memo_class'

before do
  @memos = Memo.find('memos.json')
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  erb :index
end

get '/new' do
  erb :new
end

post '/' do
  title = params[:title]
  memo = params[:memo]
  @memos.generate(title, memo)
  redirect to('/')
end

get '/:id' do
  @id = params[:id]
  @memo = @memos.show_detail(@id)
  if @memos.any? { |memo| memo['id'] == @id }
    erb :detail
  else
    status 404
  end
end

get '/:id/edit' do
  @id = params[:id]
  @memo = @memos.show_detail(@id)
  erb :edit
end

patch '/:id/edit' do
  title = params[:title]
  memo = params[:memo]
  @id = params[:id]
  @memos.edit(@id, title, memo)
  redirect to("/#{@id}")
end

delete '/:id' do
  @id = params[:id]
  @memos.delete(@id)
  redirect to('/')
end

not_found do
  erb :notfound, layout: :layout2
end
