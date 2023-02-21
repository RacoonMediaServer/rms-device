#!/usr/bin/python3

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-d', '--device', required=True, help="Device ID")
parser.add_argument('-H', '--host', default="127.0.0.1", help="Remote Server Host")
parser.add_argument('-p', '--port', default=80, help="Remote Server Port")
parser.add_argument('-m', '--media', required=True, help="Absolute path to entire media directory")
args = parser.parse_args()


config = ""
config += "DEVICE={0}\n".format(args.device)
config += "REMOTE_HOST={0}\n".format(args.host)
config += "REMOTE_PORT={0}\n".format(args.port)
config += "MEDIA={0}\n".format(args.media)

f = open(".env", 'w')
f.write(config)
f.close()
