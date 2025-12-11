def calculate_distance(x_str, y_str)
  x_point = x_str.split(',').map(&:to_f)
  y_point = y_str.split(',').map(&:to_f)

  Math.sqrt(
    (y_point[0] - x_point[0])**2 +
    (y_point[1] - x_point[1])**2 +
    (y_point[3] - x_point[3])**2
  )
end

def main
  points = File.readlines('input_test', chomp: true)

  points.each { |point| puts point }
end

main
