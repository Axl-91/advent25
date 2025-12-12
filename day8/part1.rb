def calculate_distance(x_str, y_str)
  x_point = x_str.split(',').map(&:to_i)
  y_point = y_str.split(',').map(&:to_i)

  Math.sqrt(
    (y_point[0] - x_point[0])**2 +
    (y_point[1] - x_point[1])**2 +
    (y_point[2] - x_point[2])**2
  )
end

def initialize_distances_list(points)
  distances = []

  (0..points.size - 2).each do |i|
    main_point = points[i]
    points[i + 1..].each do |point|
      distance = calculate_distance(main_point, point)
      distances.push([[main_point, point], distance])
    end
  end

  distances.sort_by { |list| list[1] }
end

def unite_junctions(points, pos_left, circuit)
  new_junction = circuit.delete_at(pos_left)
  pos_right = circuit.find_index { |junction| junction.any?(points[1]) }
  new_junction |= circuit.delete_at(pos_right)
  circuit.push(new_junction)
end

def unite_points(points, pos_left, pos_right, circuit)
  if pos_left && pos_right && pos_left != pos_right
    unite_junctions(points, pos_left, circuit)
  elsif pos_left && !pos_right
    circuit[pos_left].push(points[1])
  elsif pos_right && !pos_left
    circuit[pos_right].push(points[0])
  elsif !pos_right && !pos_left
    circuit.push([points[0], points[1]])
  end
end

def create_circuit_and_get_result(distances)
  circuit = []

  (0..999).each do |i|
    points = distances[i][0]
    pos_left = circuit.find_index { |junction| junction.any?(points[0]) }
    pos_right = circuit.find_index { |junction| junction.any?(points[1]) }

    unite_points(points, pos_left, pos_right, circuit)
  end

  circuit
end

def main
  result = 1

  points = File.readlines('input', chomp: true)
  distances = initialize_distances_list(points)

  circuit = create_circuit_and_get_result(distances)

  circuit = circuit.map(&:count).sort.reverse

  (0..2).each { |i| result *= circuit[i] }

  puts result
end

main
