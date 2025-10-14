#!/usr/bin/env python3

import argparse
import os
import subprocess
from pathlib import Path


# TODO
MAKEFILE_ENV = '__FOO_MAKEFILE'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-m', '--makefile', type=Path)
    parser.add_argument('-o', '--out-dir', type=Path, default=Path('.'))
    parser.add_argument('-v', '--verbose', action='store_true')
    parser.add_argument('-f', '--file', type=Path)
    parser.add_argument('-u', '--url')
    parser.add_argument('-i', '--isolate', action='store_true')
    parser.add_argument('-s', '--shift', type=int)
    parser.add_argument('-b', '--base')
    args = parser.parse_args()
    run(args)


def run(args):
    if args.verbose:
        print(args)

    if args.makefile is not None:
        makefile = args.makefile
    else:
        makefile = Path(os.environ[MAKEFILE_ENV])

    mk_args = []

    if args.file is not None:
        mk_args.append('FILE={}'.format(args.file.absolute()))

    if args.url is not None:
        mk_args.append('URL={}'.format(args.url))

    if args.isolate:
        mk_args.append('ISOLATE=1')

    if args.shift is not None:
        mk_args.append('SHIFT={}'.format(args.shift))

    if args.base is not None:
        mk_args.append('BASE={}'.format(args.base))

    args.out_dir.mkdir(parents=True, exist_ok=True)

    cmd = ['make', '-f', str(makefile.absolute()), '-C', str(args.out_dir)] + mk_args

    if args.verbose:
        print(cmd)

    subprocess.run(cmd).check_returncode()


if __name__ == '__main__':
    main()
