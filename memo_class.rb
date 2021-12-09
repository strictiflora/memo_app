# frozen_string_literal: true

# JSONファイルにデータを読み書きする
class Memo
  include Enumerable

  def self.load(filename)
    data = File.open(filename) { |f| JSON.parse(f.read) }
    Memo.new(data['memos'], filename)
  end

  def initialize(memos, filename)
    @memos = memos
    @filename = filename
  end

  def each(&block)
    @memos.each(&block)
  end

  def save(memos)
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

    save(@memos)
  end

  def find_memo_by_id(id)
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

    save(new_memos)
  end

  def delete(id)
    @memos.delete_if { |memo| memo['id'] == id }
    save(@memos)
  end
end
