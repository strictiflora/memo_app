# frozen_string_literal: true

require 'pg'

# dbにデータを読み書きする
class Memo
  include Enumerable

  def self.load
    connection = PG.connect( dbname: 'postgres' )
    memos = connection.exec('SELECT * FROM memos').each.to_a
    Memo.new(connection, memos)
  end

  def initialize(connection, memos)
    @connection = connection
    @memos = memos
  end

  def each(&block)
    @memos.each(&block)
  end

  def generate(title, content)
    @connection.exec('INSERT INTO memos(title, content) VALUES($1, $2)', [title, content])
  end

  def find_memo_by_id(id)
    memo = @connection.exec('SELECT id, title, content FROM memos WHERE id = $1', [id])
    memo.first
  end

  def edit(id, title, content)
    @connection.exec('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, id])
  end

  def delete(id)
    @connection.exec('DELETE FROM memos WHERE id= $1', [id])
  end
end
