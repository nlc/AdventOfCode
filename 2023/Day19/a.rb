def apply_case_flow(case_flow, rating)
  case_flow
end

fname = ARGV.shift || 'input.txt'

workflow_strs, rating_strs = File.read(fname).split(/\n\n/).map(&:split)

workflows = workflow_strs.map do |str|
  name, flow_str = str.match(/([a-z]+)\{(.*)\}/).to_a.drop(1)
  flows = flow_str.split(/,/)
  case_flows = flows[0...-1]
  else_flow = flows[-1]


  [name, [case_flows, else_flow]]
end.to_h

p workflows
