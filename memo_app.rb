# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

class Memo
  include Enumerable

  def self.find(filename)
    data = File.open(filename) { |f| JSON.parse(File.open(f).read) }
    Memo.new(data['memos'], filename)
  end

  def initialize(memos, filename)
    @memos = memos
    @filename = filename
  end

  def each(&block)
    @memos.each(&block)
  end

  def dump_in_file(memos)
    data = { 'memos' => memos }
    File.open(@filename, 'w') { |f| JSON.dump(data, f) }
  end

  def generate(title, memo)
    if @memos.empty?
      @memos << { 'id' => '1', 'title' => title, 'memo' => memo }
    else
      id = @memos[-1]['id'].to_i
      @memos << { 'id' => (id + 1).to_s, 'title' => title, 'memo' => memo }
    end

    dump_in_file(@memos)
  end

  def show_detail(id)
    @memos.find { |memo| memo['id'] == id }
  end

  def edit(id, title, memo)
    new_memos = @memos.map do |original_memo|
      if original_memo['id'] == id
        { 'id' => id, 'title' => title, 'memo' => memo }
      else
        original_memo
      end
    end

    dump_in_file(new_memos)
  end

  def delete(id)
    @memos.delete_if { |memo| memo['id'] == id }
    dump_in_file(@memos)
  end
end

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
  erb :notfound, :layout => :layout2
end
