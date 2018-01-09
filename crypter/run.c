#include "crypto.c"
#include <stdio.h>
#include <string.h>

#define BUFFER 65

int main(int argc, char *argv[]) {
  const char* input;
  char* output;

  if (argc == 2) {
    char* consoleInput = (char*) malloc(BUFFER);
    printf("Enter the message to %s \nMessage cannot exceed %i characters.\n", argv[0], BUFFER-1);
    fgets(consoleInput, BUFFER, stdin);
    output = (char*) malloc(getLength(consoleInput));
    input = consoleInput;
  }
  else if (argc == 3) {
    FILE* f;
    if((f = fopen(argv[2], "r")) == NULL) {
      printf("Failed to open file: %s", argv[2]);
      exit(1);
    }
    //Get the amount of characters from the file
    int filesize = 1; //Account for additional \n added during processing
    while(fgetc(f) != '\n') filesize++;
    char* fileInput = (char*) malloc(filesize);
    output = (char*) malloc(filesize);

    //RESET File Pointer
    fseek(f, 0, SEEK_SET);

    //Read contents into fileInput
    fgets(fileInput, filesize, f);

    input = fileInput;
  } else {
    fprintf(stderr, "Usage: KEY [file name]\n");
    exit(1);
  }

  KEY key = {1, argv[1]};
  int result = (0 == strcmp(argv[0], "./encrypt")) ? encrypt(key, input, output) : decrypt(key, input, output);

  switch (result) {
    case E_KEY_TOO_SHORT:
    fprintf(stderr, "The key entered was too short, the key-length needs to be >= 1\n");
    break;
    case E_KEY_ILLEGAL_CHAR:
    fprintf(stderr, "The key entered can only contain the letters A-Z.\n");
    break;
    case E_MESSAGE_ILLEGAL_CHAR:
    fprintf(stderr, "The message entered can only contain the letters A-Z when encrypting and @ - _ when decrypting. \n");
    break;
    case E_CYPHER_ILLEGAL_CHAR:
    fprintf(stderr, "The resulting cypher failed, it should only generate letters from @ to _ \n");
    break;
    default:
    fprintf(stdout, "The message entered was: %s\nProcessing mode: %s\nThe resulting cypher was: %s \n", input, argv[0], output);
  }

  return 0;
}
