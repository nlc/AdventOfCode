ifname = 'example_ans23.txt'

input_str = File.read('example_ans23.txt').chomp[1...-1]
input = input_str.scan(/([^\(\)\|]+|[\(\)\|])/).flatten

curr_parent_key_at_depth = ['^']
last_word = nil
last_chunk = nil

tree = {}
depth = 0
input.each do |chunk|
  case chunk
  when /[ENWS]+/
    tree[curr_parent_key_at_depth[depth]] = [] unless tree.key?(curr_parent_key_at_depth[depth])
    tree[curr_parent_key_at_depth[depth]] << chunk
    last_word = chunk
    curr_parent_key_at_depth[depth + 1] = chunk
  when /\(/
    depth += 1
  when /\)/
    if last_chunk == '|' # special case
      tree[curr_parent_key_at_depth[depth]] = [] unless tree.key?(curr_parent_key_at_depth[depth])
      tree[curr_parent_key_at_depth[depth]] << ''
    end
    depth -= 1
  when /\|/
    if last_chunk == '|' || last_chunk == '(' # special case
      tree[curr_parent_key_at_depth[depth]] = [] unless tree.key?(curr_parent_key_at_depth[depth])
      tree[curr_parent_key_at_depth[depth]] << ''
    end
    # do nothing?
  end

  last_chunk = chunk
end

p input_str
p tree
p curr_parent_key_at_depth
