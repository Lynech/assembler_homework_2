#include <gtest/gtest.h>

extern "C" void process_cstring(char *str);

TEST(process_cstring, 1) {
  char str[] = "qwerty";
  process_cstring(str);
  ASSERT_STREQ(str, "QWERTY");
}

TEST(process_cstring, 2) {
  char str[] = "qwertY";
  process_cstring(str);
  ASSERT_STREQ(str, "qwert");
}

TEST(process_cstring, 3) {
  char str[] = "Qwerty";
  process_cstring(str);
  ASSERT_STREQ(str, "Qwert");
}

TEST(process_cstring, 4) {
  char str[] = "QWERTY";
  process_cstring(str);
  ASSERT_STREQ(str, "QWERT");
}

TEST(process_cstring, 5) {
  char str[] = "QWERTYYY";
  process_cstring(str);
  ASSERT_STREQ(str, "QWERT");
}

TEST(process_cstring, 6) {
  char str[] = "Qwertyyy";
  process_cstring(str);
  ASSERT_STREQ(str, "Qwert");
}

TEST(process_cstring, 7) {
  char str[] = "Qywyeyryty";
  process_cstring(str);
  ASSERT_STREQ(str, "Qwert");
}

TEST(process_cstring, 8) {
  char str[] = "YYYQWERTY";
  process_cstring(str);
  ASSERT_STREQ(str, "QWERT");
}

TEST(process_cstring, 9) {
  char str[] = "YYYqYwYeYYrYYYYYtY";
  process_cstring(str);
  ASSERT_STREQ(str, "qwert");
}

TEST(process_cstring, 10) {
  char str[] = ".qwerty";
  process_cstring(str);
  ASSERT_STREQ(str, ".qwert");
}

TEST(process_cstring, 11) {
  char str[] = ".qwerty.";
  process_cstring(str);
  ASSERT_STREQ(str, "qwerty");
}

TEST(process_cstring, 12) {
  char str[] = "qy";
  process_cstring(str);
  ASSERT_STREQ(str, "QY");
}

TEST(process_cstring, 13) {
  char str[] = ".yqwerty";
  process_cstring(str);
  ASSERT_STREQ(str, ".qwert");
}

TEST(process_cstring, 14) {
  char str[] = " .      q werty ";
  process_cstring(str);
  ASSERT_STREQ(str, ".qwerty");
}

TEST(process_cstring, 15) {
  char str[] = "";
  process_cstring(str);
  ASSERT_STREQ(str, "");
}

TEST(process_cstring, 16) {
  char str[] = ".";
  process_cstring(str);
  ASSERT_STREQ(str, "");
}

TEST(process_cstring, 17) {
  char str[] = "y";
  process_cstring(str);
  ASSERT_STREQ(str, "Y");
}

TEST(process_cstring, 18) {
  ASSERT_EXIT((process_cstring(nullptr), exit(0)), ::testing::ExitedWithCode(0),
              ".*");
}