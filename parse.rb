#!/usr/bin/env ruby

def parse_manifest(manifest)
  output = ""
  in_params = false
  default = 'check module data'
  File.open(manifest) do |infile|
    while (line = infile.gets.tr(',',''))
      if line[0] == ')'
        break
      end
      if in_params 
        if line.include?('=')
          default = line.split('=')[-1].strip
          variable_name = line.split[1][1..-1]
        else
          variable_name = line.split[1][1,-1]
        end
        datatype = line.split('$')[0].strip
        output += "* `#{variable_name}` (#{datatype}, Default: #{default}): \n"
      end
      if line[0..4] == 'class'
        output += "#### #{line.split[1]}\n"
        in_params = true
      end
    end
  end
  output
end

def main
  dir = ARGV[0]
  output = "### Classes\n\n"
  Dir["#{dir}/*.pp"].each do |manifest|
    output += parse_manifest(manifest)
  end
  puts output
end

main
