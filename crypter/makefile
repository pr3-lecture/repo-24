# Makefile for the crypter program
# Author: Richard Vladimirskij
# University of Applied Sciences Mannheim
# Programming 3 // Prof. Smits
.PHONY: all create clean runtest

create: encrypt decrypt cryptoTests

all: encrypt decrypt cryptoTests runtest clean

runtest:
	./cryptoTests

encrypt: encrypt.o
	cc -o encrypt run.o

decrypt: decrypt.o
	cc -o decrypt run.o

cryptoTests: cryptoTests.o
	cc -o cryptoTests cryptoTests.o

encrypt.o: run.c
	cc -Wall -c run.c

decrypt.o: run.c
	cc -Wall -c run.c

cryptoTests.o: cryptoTests.c
	cc -Wall -c cryptoTests.c

clean:
	rm -f run.o cryptoTests.o run.o cryptoTests decrypt encrypt
