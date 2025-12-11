def main
  points = File.readlines('input_test', chomp: true)

  points.each { |point| puts point }
end

main
