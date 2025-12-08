#include <fstream>
#include <iostream>
#include <ostream>
#include <sstream>
#include <string>
#include <vector>

std::vector<std::string> split_whitespaces(const std::string &line) {
  std::istringstream stream(line);
  std::vector<std::string> words;
  std::string word;

  while (stream >> word) {
    words.push_back(word);
  }
  return words;
}

template <typename T> void print_vec(const std::vector<T> &v) {
  std::cout << "[";
  for (size_t i = 0; i < v.size(); i++) {
    std::cout << v[i];
    if (i < v.size() - 1)
      std::cout << ", ";
  }
  std::cout << "]\n";
}

long run_sum(std::vector<std::string> sum) {
  long total = 0;
  
  for (std::string num: sum) {
    total += std::stoi(num);
  }
  return total;
}

long run_mult(std::vector<std::string> mult) {
  long total = 1;
  
  for (std::string num: mult) {
    total *= std::stoi(num);
  }
  return total;
  
}

long run_operations(std::vector<std::vector<std::string>> operations_vector) {
  long total = 0;
  for (std::vector<std::string> operation : operations_vector) {
    print_vec(operation);
    std::string op = operation.back();
    operation.pop_back();

    if (op == "+") {
      long sum = run_sum(operation);
      std::cout << "Sum total: " << sum << std::endl;
      total += sum;
    } else {
      long mult = run_mult(operation);
      std::cout << "Mult total: " << mult << std::endl;
      total += mult;
    }
  }
  return total;
}

int main() {
  std::ifstream file("input");
  std::vector<std::vector<std::string>> operations_vector;

  if (file.is_open()) {
    std::string line;

    while (std::getline(file, line)) {
      std::vector<std::string> words = split_whitespaces(line);

      if (operations_vector.size() == 0) {
        for (std::string word : words) {
          std::vector<std::string> operation = {word};
          operations_vector.push_back(operation);
        }
      } else {
        for (int i = 0; i < operations_vector.size(); i++) {
          operations_vector[i].push_back(words[i]);
        }
      }
    }

    file.close();
  }

  long result = run_operations(operations_vector);
  std::cout << "The result is: " << result << std::endl;

  return 0;
}
