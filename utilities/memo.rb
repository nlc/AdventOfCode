$memo_table = {}

def _memo_init()
  $memo_table = {}
end

def fuck
  puts 'fuck'
end

def _memo(method, *args)
  memo_key = [method, args]
  return $memo_table[memo_key] if $memo_table.key? memo_key
  $memo_table[memo_key] = send(method, *args)
end

# Note that this implementation is crude. _memo() will have to wrap EVERY
# call to self in a recursive function in order for this to work, e.g.
#   def fib2(x)
#     return x if x <= 3
#     _memo(:fib2, x - 1) + _memo(:fib2, x - 2)
#   end
# There's no fancy metaprogramming here to "memo-ify" a pre-existing method.
