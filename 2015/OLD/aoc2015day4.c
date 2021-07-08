#include <stdio.h>
#include <stdlib.h>
#include <CommonCrypto/CommonCrypto.h>

bool test(unsigned char *digest) {
  int numZeros = 5; // parametrizeable
  int numBytes = numZeros / 2;
  int extra = numZeros % 2;
  int i;
  for(i = 0; i < numBytes; i++) {
    if(digest[i]) {
      return false;
    }
  }
  if(extra > 0) {
    if((digest[i] >> 4) & 0xF) {
      return false;
    }
  }
  return true;
}

int main(void) {
  char preamble[] = "bgvyzdsv";
  unsigned char message[20];
  bool found = false;
  unsigned char digest[20];
  // for(int i = 0; i < 10000000 && !found; i++) {
  for(int i = 0; i < 1000000000 && !found; i++) {
    CC_LONG length = sprintf((char *)message, "%s%d", preamble, i);
    CC_MD5((const void *)message, length, digest);

    if(test(digest)) {
      found = true;
      printf("%d  -->  ", i);
      for(int x = 0; x < CC_MD5_DIGEST_LENGTH; x++) {
        printf("%02x", digest[x]);
      }
      printf("\n");
    }
  }
}
