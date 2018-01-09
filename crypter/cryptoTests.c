#include <stdio.h>
#include <stdlib.h>
#include "crypto.c"

#define mu_assert(message, test) do { if (!(test)) return message; return 0;} while (0)
#define mu_run_test(test) do { char *message = test(); tests_run++; if (message) return message; } while (0)

int tests_run = 0;

/* Compares two strings, letter for letter and returns 0 if equal and -1 if
 * the strings are not equal
 */
int isEqual(char* a, char* b) {
  int length_of_a = getLength(a);
  int length_of_b = getLength(b);
  if(length_of_a != length_of_b) {
    return -1;
  }

  for(int i = 0; i < length_of_a; i++) {
    if(a[i] != b[i]) {
      return -1;
    }
  }

  return 0;
};

static char* testForKeyTooShort() {
  char* input = "HALLO";
  char* output = (char*) malloc(getLength(input));
  KEY key;
  key.type = 1;
  key.chars = "";
  int funcall_result = encrypt(key, input, output);
  mu_assert("Testing for a key that's too short FAILED. \n", funcall_result == 1);
}

static char* testForKeyOk() {
  char* input = "HALLO";
  char* output = (char*) malloc(getLength(input));
  KEY key;
  key.type = 1;
  key.chars = "A";
  int funcall_result = encrypt(key, input, output);
  mu_assert("Testing for a key with a valid key length FAILED. \n", funcall_result == 0);
}

static char* testForIllegalCharInKeyTooSmall() {
  char* input = "HALLO";
  char* output = (char*) malloc(getLength(input));
  KEY key;
  key.type = 1;
  key.chars = "@"; //Is the first symbol smaller than A
  int funcall_result = encrypt(key, input, output);
  mu_assert("Testing for an illegal character (smaller than A) in the key FAILED", funcall_result == 2);
}

static char* testForIllegalCharInKeyTooLarge() {
  char* input = "HALLO";
  char* output = (char*) malloc(getLength(input));
  KEY key;
  key.type = 1;
  key.chars = "["; //Is the first symbol larger than Z
  int funcall_result = encrypt(key, input, output);
  mu_assert("Testing for an illegal character (larger than Z) in the key FAILED", funcall_result == 2);
}

static char* testForSmallestAllowedCharacterIsKey() {
  char* input = "HALLO";
  char* output = (char*) malloc(getLength(input));
  KEY key;
  key.type = 1;
  key.chars = "A";
  int funcall_result = encrypt(key, input, output);
  mu_assert("Test for the smallest allowed character as key has FAILED", funcall_result == 0);
}

static char* testForLargestAllowedCharacterIsKey() {
  char* input = "HALLO";
  char* output = (char*) malloc(getLength(input));
  KEY key;
  key.type = 1;
  key.chars = "Z";
  int funcall_result = encrypt(key, input, output);
  mu_assert("Test for the largest allowed character as key has FAILED", funcall_result == 0);
}

static char* testForInputMessageContainsIllegalCharacterSmall() {
  char* input = "H@LLO";
  char* output = (char*) malloc(getLength(input));
  KEY key;
  key.type = 1;
  key.chars = "MYKEY";
  int funcall_result = encrypt(key, input, output);
  mu_assert("Test for messages contains illegal character (small) has FAILED", funcall_result == 3);
}

static char* testForInputMessageContainsIllegalCharacterLarge() {
  char* input = "HA[LO";
  char* output = (char*) malloc(getLength(input));
  KEY key;
  key.type = 1;
  key.chars = "MYKEY";
  int funcall_result = encrypt(key, input, output);
  mu_assert("Test for messages contains illegal character (large) has FAILED", funcall_result == 3);
}

static char* testEncryptReturnCode() {
  char* input = "HALLO";
  char* output = (char*) malloc(getLength(input));
  KEY key;
  key.type = 1;
  key.chars = "MYKEY";
  int funcall_result = encrypt(key, input, output);
  mu_assert("Test of encrypt method return code with valid inputs has FAILED", funcall_result == 0);
}

static char* testEncryptExpectedOutput() {
  char* input = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  char* output = (char*) malloc(getLength(input));
  char* expected_output = "URFVPJB[]ZN^XBJCEBVF@ZRKMJ";
  KEY key;
  key.type = 1;
  key.chars = "TPERULES";
  encrypt(key, input, output);
  int equal = isEqual(output, expected_output);
  mu_assert("Test of encrypt method with expected output has FAILED", equal == 0);
}

static char* testDecryptExpectedOutput() {//An encrypted string as in input
  char* input = "URFVPJB[]ZN^XBJCEBVF@ZRKMJ";
  char* output = (char*) malloc(getLength(input));
  char* expected_output = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  KEY key;
  key.type = 1;
  key.chars = "TPERULES";
  decrypt(key, input, output);
  int equal = isEqual(output, expected_output);
  mu_assert("Test of encrypt method with expected output has FAILED", equal == 0);
}

static char* allTests() {
  mu_run_test(testForKeyTooShort);
  mu_run_test(testForKeyOk);
  mu_run_test(testForIllegalCharInKeyTooSmall);
  mu_run_test(testForIllegalCharInKeyTooLarge);
  mu_run_test(testForSmallestAllowedCharacterIsKey);
  mu_run_test(testForLargestAllowedCharacterIsKey);
  mu_run_test(testForInputMessageContainsIllegalCharacterSmall);
  mu_run_test(testForInputMessageContainsIllegalCharacterLarge);
  mu_run_test(testEncryptReturnCode);
  mu_run_test(testEncryptExpectedOutput);
  mu_run_test(testDecryptExpectedOutput);
  return 0;
}

int main(int argc, char const *argv[]) {
  char *result = allTests();

  if (result != 0) printf("%s\n", result);
  else             printf("ALL TESTS PASSED\n");

  printf("Tests run: %d\n", tests_run);

  return result != 0;
}
