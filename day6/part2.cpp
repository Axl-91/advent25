#include <fstream>
#include <iostream>
#include <numeric>
#include <sstream>
#include <string>
#include <vector>

template <typename T> void print_vec(const std::vector<T> &v) {
  std::cout << "[";

  for (size_t i = 0; i < v.size(); i++) {
    std::cout << v[i];
    if (i < v.size() - 1)
      std::cout << ", ";
  }
  std::cout << "]\n";
}

int count_operations(const std::string &operations_line) {
  std::istringstream stream(operations_line);
  int operations_count = 0;
  std::string operation;

  while (stream >> operation) {
    operations_count++;
  }

  return operations_count;
}

long run_sum(std::vector<std::string> sum) {
  long total = 0;

  for (std::string num : sum) {
    total += std::stoi(num);
  }
  return total;
}

long run_mult(std::vector<std::string> mult) {
  long total = 1;

  for (std::string num : mult) {
    total *= std::stoi(num);
  }
  return total;
}

long long run_operations(std::vector<std::vector<long long>> numbers,
                         std::vector<std::string> operation) {
  long long total = 0;

  for (int i = 0; i < numbers.size(); i++) {
    if (operation[i] == "+") {
      long long sum = std::accumulate(numbers[i].begin(), numbers[i].end(), 0);
      total += sum;
    } else {
      long long mult = std::accumulate(
          numbers[i].begin(), numbers[i].end(), 1LL,
          [](long long acc, long long val) { return acc * val; });
      total += mult;
    }
  }
  return total;
}

void parse_numbers(std::vector<std::vector<long long>> &num_vector,
                   std::vector<int> pos_numbers, std::string line) {
  int vec_selected = 0;
  int num_position = 0;

  for (int i = 0; i < line.size(); i++) {
    // std::cout << "i -> " << i << std::endl;

    if (num_position + 1 < pos_numbers.size() &&
        i == pos_numbers[num_position + 1]) {
      vec_selected++;
      num_position++;
    }

    if (line[i] == ' ') {
      continue;
    }
    // std::cout << "vec_selected -> " << vec_selected << std::endl;
    // std::cout << "num_position -> " << num_position << std::endl;
    // std::cout << "new_number -> " << pos_numbers[num_position] << std::endl;

    int pos = i - (pos_numbers[num_position]);
    long long new_num = line[i] - '0';
    // std::cout << "ADD: " << new_num << " | To Vector in [" << vec_selected <<
    // ", " << pos << "]" << std::endl;
    num_vector[vec_selected][pos] =
        num_vector[vec_selected][pos] * 10 + new_num;

    // print_vec(num_vector[vec_selected]);
  }
}

std::vector<std::string> parse_operators(std::string operators_str) {
  std::istringstream stream(operators_str);
  std::vector<std::string> operators_vec;
  std::string operator_str;

  while (stream >> operator_str) {
    operators_vec.push_back(operator_str);
  }
  return operators_vec;
}

void init_pos_numbers(std::string operators_line,
                      std::vector<int> &pos_numbers) {
  for (int i = 0; i < operators_line.size(); i++) {
    if (operators_line[i] != ' ') {
      pos_numbers.push_back(i);
    }
  }
}

int main() {
  std::ifstream file("input");
  if (!file.is_open()) {
    std::cerr << "Failed to open file\n";
    return 1;
  }

  std::vector<std::vector<long long>> numbers;
  std::vector<int> pos_numbers;
  std::vector<std::string> operators;
  std::string line;
  int line_len;

  std::getline(file, line);
  int operations_count = count_operations(line);

  while (std::getline(file, line)) {
    if (line[0] == '*' || line[0] == '+') {
      operators = parse_operators(line);
      init_pos_numbers(line, pos_numbers);
      line_len = line.size();
    }
  }

  for (int i = 0; i < operations_count; i++) {
    std::vector<long long> num_vector;
    int next_number =
        (i + 1 < pos_numbers.size()) ? pos_numbers[i + 1] : line_len + 1;
    int numbers_count = next_number - pos_numbers[i] - 1;
    for (int j = 0; j < numbers_count; j++) {
      num_vector.push_back(0);
    }
    numbers.push_back(num_vector);
  }

  file.clear();
  file.seekg(0);

  while (std::getline(file, line)) {
    if (line[0] == '*' || line[0] == '+') {
      continue;
    }
    parse_numbers(numbers, pos_numbers, line);
  }

  file.close();

  long long result = run_operations(numbers, operators);
  std::cout << "Result: " << result << std::endl;

  return 0;
}
