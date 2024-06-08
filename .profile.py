#! python3.12
# Set ‘PYTHONSTARTUP’ environment variable to ‘~/.profile.py’ (this file).
import string, re, difflib, textwrap, unicodedata, stringprep, readline, rlcompleter  # 文本处理服务
import struct, codecs  # 二进制数据服务
import datetime, zoneinfo, calendar, collections, collections.abc, heapq, bisect, array, weakref, types, copy, pprint, reprlib, enum, graphlib  # 数据类型
import numbers, math, cmath, decimal, fractions, random, statistics  # 数字和数学模块
import itertools, functools, operator  # 函数式编程模块
import pathlib, os.path, fileinput, stat, filecmp, tempfile, glob, fnmatch, linecache, shutil  # 文件和目录访问
import pickle, copyreg, shelve, marshal, dbm, sqlite3  # 数据持久化
import zlib, gzip, bz2, lzma, zipfile, tarfile  # 数据压缩和存档
import csv, configparser, tomllib, netrc, plistlib  # 文件格式
import hashlib, hmac, secrets  # 加密服务
import os, io, time, argparse, getopt, logging, logging.config, logging.handlers, getpass, platform, errno, ctypes  # 通用操作系统服务
import threading, multiprocessing, multiprocessing.shared_memory, concurrent.futures, subprocess, sched, queue, contextvars  # 并发执行
import asyncio, socket, ssl, select, selectors, signal, mmap  # 网络和进程间通信
import email, json, mailbox, mimetypes, base64, binascii, quopri  # 互联网数据处理
import html, html.parser, html.entities, xml.etree.ElementTree, xml.dom, xml.dom.minidom, xml.dom.pulldom, xml.sax, xml.sax.handler, xml.sax.saxutils, xml.sax.xmlreader, xml.parsers.expat  # 结构化标记处理工具
import webbrowser, wsgiref, urllib, urllib.request, urllib.response, urllib.parse, urllib.error, urllib.robotparser, http, http.client, ftplib, poplib, imaplib, smtplib, uuid, socketserver, http.server, http.cookies, http.cookiejar, xmlrpc, xmlrpc.client, xmlrpc.server, ipaddress  # 互联网协议和支持
import wave, colorsys  # 多媒体服务
import gettext, locale  # 国际化
import turtle, cmd, shlex  # 程序框架
import typing, pydoc, doctest, unittest, unittest.mock  # 开发工具
import bdb, faulthandler, pdb, timeit, trace, tracemalloc  # 调试和分析
import ensurepip, venv, zipapp  # 软件打包和分发
import sys, sysconfig, builtins, warnings, dataclasses, contextlib, abc, atexit, traceback, gc, inspect, site  # Python 运行时服务
import code, codeop  # 自定义 Python 解释器
import zipimport, pkgutil, modulefinder, runpy, importlib, importlib.resources, importlib.resources.abc, importlib.metadata  # 导入模块
import ast, symtable, token, keyword, tokenize, tabnanny, pyclbr, py_compile, compileall, dis, pickletools  # Python 语言服务
import msvcrt, winreg, winsound  # MS-Windows 相关模块


sys.ps1, sys.ps2 = "\033[32m►\033[0m", "\033[32m▻\033[0m"  # 提示符

if os.path.isfile(".pythonrc.py"):
    exec(open(".pythonrc.py").read())
