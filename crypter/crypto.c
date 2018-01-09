/*
* Crypto Exercise
*
* @author Richard Vladimirskij
*
* University of Applied Sciences Mannheim
* Lecture: Programming 3 in WS 2017/18
* Prof. Smits
*/
#include <stdio.h>
#include <stdlib.h>
#include "crypto.h"



/*
* Returns the length of msg
*/
int getLength(const char *msg) {
  int length = 0;
  int containsReturn = 0;
  while(msg[length] != '\0') {
    if(msg[length] == '\n') containsReturn = 1;
    length++;
  }
  if(containsReturn) length--;
  return length;
}


int xorEncryption(char* key, const char* input, char* output, char mode) {

  int key_length = getLength(key);
  if(key_length < 1) {
    return 1; //Key too short
  }

  //Encrypt / Decrypt input
  int input_length = getLength(input);

  for(int i = 0; i < input_length; i++) {
    int key_val = (key[i % key_length] - '@');
    if(key_val < 1 || key_val > 26) return 2; //A to Z invalid


    int input_val = (input[i] - '@');

    //Check validity of input character based on procedure E = encrypt, D = decrypt
    switch (mode) {
      case 'E':
      if(input_val < 1 || input_val > 26) { //Only A to Z are valid
        return 3;
      };
      break;
      case 'D':
      if(input_val < 0 || input_val > 32) { //Only @ to _ are valid
        return 3;
      };
      break;
      default:
      return 6;
    }

    int xor_val = (input_val ^ key_val);
    if(xor_val < 0 || xor_val > 32) return 4; //@ to _ Valid

    output[i] = (xor_val + '@');
  }

  return 0;
}

int encrypt(KEY key, const char* input, char* output) {
  char mode = 'E';
  if(key.type == 1) {//XOR Encryption is defined as type = 1
    return xorEncryption(key.chars, input, output, mode);
  }
  return -1;
}

int decrypt(KEY key, const char* input, char* output) {
  char mode = 'D';
  if(key.type == 1) {//XOR Encryption is defined as type = 1
    return xorEncryption(key.chars, input, output, mode);
  }
  return -1;
}
