# python3.14
# Set ‘PYTHONSTARTUP’ environment variable to ‘~/.profile.py’ (this file).

# 文本处理服务
import string
import re
import difflib
import textwrap
import unicodedata
import stringprep
try:
    import readline
except ModuleNotFoundError as err:
    print(err, file=__import__('sys').stderr)
import rlcompleter

# 二进制数据服务
import struct
import codecs

# 数据类型
import datetime
import zoneinfo
import calendar
import collections
import collections.abc
import heapq
import bisect
import array
import weakref
import types
import copy
import pprint
import reprlib
import enum
import graphlib

# 数字和数学模块
import numbers
import math
import cmath
import decimal
import fractions
import random
import statistics

# 函数式编程模块
import itertools
import functools
import operator

# 文件和目录访问
import pathlib
import os.path
import stat
import filecmp
import tempfile
import glob
import fnmatch
import linecache
import shutil

# 数据持久化
import pickle
import copyreg
import shelve
import marshal
import dbm
import sqlite3

# 数据压缩和存档
import zlib
import gzip
import bz2
import lzma
import zipfile
import tarfile

# 文件格式
import csv
import configparser
import tomllib
import netrc
import plistlib

# 加密服务
import hashlib
import hmac
import secrets

# 通用操作系统服务
import os
import io
import time
import logging
import logging.config
import logging.handlers
import platform
import errno
import ctypes

# 命令行界面库
import argparse
import optparse
import getpass
import fileinput
try:
    import curses
    import curses.textpad
    import curses.ascii
    import curses.panel
except ModuleNotFoundError as err:
    print(err, file=__import__('sys').stderr)
import cmd

# 并发执行
import threading
import multiprocessing
import multiprocessing.shared_memory
import concurrent.futures
import subprocess
import sched
import queue
import contextvars
import _thread

# 网络和进程间通信
import asyncio
import socket
import ssl
import select
import selectors
import signal
import mmap

# 互联网数据处理
import email
import json
import mailbox
import mimetypes
import base64
import binascii
import quopri

# 结构化标记处理工具
import html
import html.parser
import html.entities
## XML处理模块
import xml.etree.ElementTree
import xml.dom
import xml.dom.minidom
import xml.dom.pulldom
import xml.sax
import xml.sax.handler
import xml.sax.saxutils
import xml.sax.xmlreader
import xml.parsers.expat

# 互联网协议和支持
import webbrowser
import wsgiref
import urllib
import urllib.request
import urllib.response
import urllib.parse
import urllib.error
import urllib.robotparser
import http
import http.client
import ftplib
import poplib
import imaplib
import smtplib
import uuid
import socketserver
import http.server
import http.cookies
import http.cookiejar
import xmlrpc
import xmlrpc.client
import xmlrpc.server
import ipaddress

# 多媒体服务
import wave
import colorsys

# 国际化
import gettext
import locale

# 开发工具
import typing
import pydoc
import doctest
import unittest
import unittest.mock
import unittest.mock
import test
import test.support
import test.support.socket_helper
import test.support.script_helper
import test.support.bytecode_helper
import test.support.threading_helper
import test.support.os_helper
import test.support.import_helper
import test.support.warnings_helper

# 调试和分析
## 审计事件表
import bdb
import faulthandler
import pdb
import cProfile
import profile
import timeit
import trace
import tracemalloc

# 软件打包和分发
import ensurepip
import venv
import zipapp

# Python 运行时服务
import sys
import sysconfig
import builtins
import warnings
import dataclasses
import contextlib
import abc
import atexit
import traceback
import __future__
import gc
import inspect
import site

# 自定义 Python 解释器
import code
import codeop

# 导入模块
import zipimport
import pkgutil
import modulefinder
import runpy
import importlib
import importlib.resources
import importlib.resources.abc
import importlib.metadata

# Python 语言服务
import ast
import symtable
import token
import keyword
import tokenize
import tabnanny
import pyclbr
import py_compile
import compileall
import dis
import pickletools

# Windows系统相关模块
if os.name == 'nt':
    import msvcrt
    import winreg
    import winsound

# Unix 专属服务
import shlex
import posix
import pwd
import grp
import termios
import tty
import pty
import fcntl
import resource
import syslog

# 被取代的模块
import getopt



sys.ps1, sys.ps2 = "\033[32m►\033[0m", "\033[32m▻\033[0m"  # 提示符

if os.path.isfile(".pythonrc.py"):
    exec(open(".pythonrc.py").read())
