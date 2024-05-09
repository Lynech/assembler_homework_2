#include <iostream>
#include <string>

extern "C" void process_cstring(char *str);

void the_programm(char *str) {
  std::cout << str << std::endl;
  process_cstring(str);
  std::cout << str << std::endl;
}

int main() {
  std::string str;
  while (getline(std::cin, str))
    the_programm(str.data());
  return 0;
}
