graph = {} of String => Set(String)
parents_of = {} of String => Set(String)

non_frontier = Set(String).new

File.read_lines("graph.txt").map do |vertex|
  k, v = vertex.split(/ /)

  non_frontier << v

  if graph.has_key? k
    graph[k] << v
  else
    graph[k] = [v].to_set
  end

  if parents_of.has_key? v
    parents_of[v] << k
  else
    parents_of[v] = [k].to_set
  end
end

# Ideally this would be some kind of heap. Whatever, N = 26.
frontier = Set.new(graph.keys) - non_frontier

max_workers = 5
free_workers = (0...max_workers).to_set
engaged_workers = Set(Int32).new
worker_tasks = Array(String).new(max_workers, ".")
worker_task_durations = Array(Int32).new(max_workers, -1)
tasks_in_progress = Set(String).new

completed = ""
elapsed = 0

def task_duration(task)
  (task.bytes.first - 4).to_i
end

while(!frontier.empty?)
  next_nodes = frontier.to_a.sort { |a, b| a <=> b }
  while engaged_workers.size < max_workers && !next_nodes.empty?
    next_node = next_nodes.shift

    if !tasks_in_progress.includes? next_node
      worker = free_workers.first
      engaged_workers << worker
      free_workers.delete(worker)
      worker_tasks[worker] = next_node
      worker_task_durations[worker] = task_duration(next_node)
      tasks_in_progress << next_node
    end
  end

  puts "#{worker_tasks.join(' ')}\t#{elapsed}"

  # Advance the clock
  min_remaining = worker_task_durations.select{|x|x>=0}.min
  elapsed += min_remaining
  worker_tasks.each_with_index do |task, worker|
    worker_task_durations[worker] -= min_remaining
    if worker_task_durations[worker] == 0
      worker_tasks[worker] = "."
      worker_task_durations[worker] = -1
      engaged_workers.delete(worker)
      free_workers << worker
      # completed += task

      tasks_in_progress.delete(task)

      if graph.has_key? task
        graph[task].each do |child|
          if parents_of.has_key? child
            parents_of[child].delete(task)

            if parents_of[child].empty?
              frontier << child
            end
          end
        end
      end
      frontier.delete(task)
    end
  end

  # frontier.delete(next_node)
end

puts elapsed
