#!/usr/bin/python3

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-D', '--device', required=True, help="Device ID")
parser.add_argument('-H', '--host', default="127.0.0.1", help="Remote Server Host")
parser.add_argument('-I', '--ip', default="127.0.0.1", help="Interface IP address for binding")
parser.add_argument('-P', '--port', default=80, help="Remote Server Port")
parser.add_argument('-m', '--media', required=True, help="Absolute path to entire media directory")
parser.add_argument('-d', '--data', required=True, help="Absolute path to entire data directory")
parser.add_argument('-u', '--user', default="admin", help="Admin user nickname")
parser.add_argument('-p', '--password', required=True, help="Admin password")
args = parser.parse_args()


config = ""
config += "DEVICE={0}\n".format(args.device)
config += "REMOTE_HOST={0}\n".format(args.host)
config += "REMOTE_PORT={0}\n".format(args.port)

config += "\nINTERFACE_IP={0}\n".format(args.ip)

config += "\nMEDIA={0}\n".format(args.media)
config += "DATA={0}\n".format(args.data)

config += "\nUSER={0}\n".format(args.user)
config += "PASSWORD={0}\n".format(args.password)

config += '\nPOSTGRES_DATABASES="gitea,gitea: nextcloud,user_nextcloud: rms,rms"\n'

f = open(".env", 'w')
f.write(config)
f.close()
