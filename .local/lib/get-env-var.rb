# frozen_string_literal: true

if !defined?(@var_name)
  $stderr.puts "`var_name` is undefined"
  exit 2
end

if !ENV.key?(@var_name)
  $stderr.puts "#{@var_name} is not set"
  exit 1
end

printf "%s", ENV[@var_name]
