#!/usr/bin/env python
import argparse

try:
    import ConfigParser
except ImportError:
    import configparser as ConfigParser

from jinja2 import Environment, FileSystemLoader

parser = argparse.ArgumentParser(description='Get variables from config file and update input file')
parser.add_argument('-c', '--config', required=True, help='config file')
parser.add_argument('-f', '--file', required=True, help='File to update the values we get from the config file')
args = parser.parse_args()

config = ConfigParser.SafeConfigParser()
config.readfp(open(args.config))

env = Environment(loader=FileSystemLoader(searchpath="."), keep_trailing_newline = True)

template = env.get_template(args.file)
f = open(args.file, 'w')
f.write(template.render(dict(config.items('variables'))))
f.close
