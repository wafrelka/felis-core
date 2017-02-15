import subprocess, os

if __name__ == '__main__':

    srcs = ['fib/fib9.bin',
        'loopback/loopback.bin',
        'man_easy/man_easy32.bin',
        'man_easy/man_easy.bin',
        'loopback/hard_loopback.bin']

    for src in srcs:

        fname = os.path.basename(src)
        dest = os.path.join('exe', fname + '.exe')

        subprocess.call(['python', 'push.py', src, dest])
