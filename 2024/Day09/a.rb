puts "hello world"

def fake_rle_old(str)
  pos = 0
  str.chars.map.with_index do |ch, i|
    if i.odd?
      id = (i - 1) / 2

      [pos, id]
    else
      i
    end

    pos += ch.to_i
  end
end

def fake_rle(str)
  index = 0
  id = 0

  str.chars.each_slice(2).map do |runs|
    curr_index = index
    curr_id = id

    case runs.length
    when 2
      file_run, blank_run = runs.map(&:to_i)

      index += file_run + blank_run
      id += 1

      [curr_id, curr_index, file_run]
    when 1
      file_run = runs.first.to_i

      index += file_run

      [curr_id, curr_index, file_run]
    else
      raise "Bad assumption!"
    end
  end
end

sample = '2333133121414131402'
answer = '00...111...2...333.44.5555.6666.777.888899'
p fake_rle(sample)
