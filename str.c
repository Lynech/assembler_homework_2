static char check_attribute(char const *str) {
  char result = 0;
  if (str && *str >= 'a' && *str <= 'z') {
    while (*str != '\0')
      ++str;
    if (*(str - 1) >= 'a' && *(str - 1) <= 'z')
      result = 1;
  }
  return result;
}

static void rule_1(char *str) {
  if (str)
    for (; *str != '\0'; ++str)
      if (*str >= 'a' && *str <= 'z')
        *str += ('A' - 'a');
      else if (*str >= 'A' && *str <= 'Z')
        *str += ('a' - 'A');
}

static void rule_2(char *str) {
  if (str) {
    char *ptr = str;
    char last = *ptr;
    for (; *ptr != '\0'; ++ptr)
      last = *ptr;
    ptr = str;
    int i = 0;
    for (; *ptr != '\0'; ptr++) {
      *(ptr - i) = *ptr;
      if (*ptr == last)
        ++i;
    }
    *(ptr - i) = '\0';
  }
}

void process_cstring(char *str) {
  if (check_attribute(str))
    rule_1(str);
  else
    rule_2(str);
}