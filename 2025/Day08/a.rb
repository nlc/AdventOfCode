require 'algorithms'
include Containers

infile = 'input.txt'
num_mins = 1000

points =
  File.readlines(infile, chomp: true).map do |line|
    line.split(/,/).map(&:to_i)
  end

def r2(p1, p2)
  p1.zip(p2).sum{|a, b|(a-b)**2}
end

mh = MinHeap.new([[Float::INFINITY, []]] * num_mins) { |a, b| (a[0] <=> b[0]) == -1 }
points.length.times do |ip1|
  ip1.times do |ip2|
    mh.push([r2(points[ip1], points[ip2]), [ip1, ip2]])
  end
end

ips_in_group = {}
group_id_for_ip = {}
latest_group_id = 0
num_mins.times do
  dist, ips = mh.pop
  ip1, ip2 = ips
  p1, p2 = ips.map { |ip| points[ip] }

  if group_id_for_ip.key?(ip1)
    if group_id_for_ip.key?(ip2)
      if (gid1 = group_id_for_ip[ip1]) != (gid2 = group_id_for_ip[ip2]) # both are in diff. groups; merge
        ips_in_group[latest_group_id] = ips_in_group[gid1].clone + ips_in_group[gid2].clone
        ips_in_group[latest_group_id].each do |ip|
          group_id_for_ip[ip] = latest_group_id
        end

        ips_in_group.delete(gid1)
        ips_in_group.delete(gid2)

        latest_group_id += 1
      end
    else # p1 is in a group, bring in p2
      ips_in_group[group_id_for_ip[ip1]] << ip2
      group_id_for_ip[ip2] = group_id_for_ip[ip1]
    end
  else
    if group_id_for_ip.key?(ip2) # p2 is in a group, bring in p1
      ips_in_group[group_id_for_ip[ip2]] << ip1
      group_id_for_ip[ip1] = group_id_for_ip[ip2]
    else # neither point has been assigned a group yet; create a new one
      ips_in_group[latest_group_id] = [ip1, ip2]
      group_id_for_ip[ip1] = latest_group_id
      group_id_for_ip[ip2] = latest_group_id

      latest_group_id += 1
    end
  end
end

p ips_in_group.map { |gid, ips| ips.length }.max(3).inject(:*)
