#!/usr/bin/python3

import sys, os, struct


if __name__ == '__main__':

    if len(sys.argv) < 3:
        print("usage: ./push.py <binfile_path> <uart_path>")
        exit(1)

    bin_path = sys.argv[1]
    uart_path = sys.argv[2]

    size = os.stat(bin_path).st_size

    print("from: %s" % bin_path)
    print("to  : %s" % uart_path)
    print("size: %d" % size)

    with open(uart_path, "wb") as uart:
        uart.write(struct.pack("<I", size))
        with open(bin_path, "rb") as binary:
            while True:
                data = binary.read(1024)
                if not data:
                    break
                uart.write(data)
                sys.stdout.write(".")
                sys.stdout.flush()
            sys.stdout.write("\n")

    print("finished")
