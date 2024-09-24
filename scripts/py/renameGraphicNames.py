# -*- coding: utf8 -*-
# Filename: renameFiles.py
#
########################################################################
# This is a program to rename files and folders in
# a given folder by applying a set of renaming rules
#
# Martina Trognitz (martina.trognitz@oeaw.ac.at)
#
# Specify the path with the variable path
# To see if rules work without actually renaming, set rename to false
#
########################################################################
from __future__ import unicode_literals

from builtins import list, str
from io import open
from lxml import etree as ET

import os, os.path
import unicodedata
import re
import glob


# list of files that should be ignored, such as system files like 'Thumbs.db'
ignoreFiles = ['Thumbs.db', '.DS_Store']

# list of file formats in lower case that should be ignored, such as 'xlsx'
ignoreFileExtensions = []

def normaliseName(value):
    """
    Normalises or renames a string, replaces 'something' with 'something else'
    add anything else you need; examples are commented

    Order of rules does matter for custom replacements.

    At the end all remaining invalid characters are removed (i.e. replaced with '')
    """
    # split into name and extension
    newValue, fileExt = os.path.splitext(value)
    # replace umlauts with two letters
    newValue = newValue.replace('ä','ae')
    newValue = newValue.replace('ö','oe')
    newValue = newValue.replace('ü','ue')
    newValue = newValue.replace('Ä','Ae')
    newValue = newValue.replace('Ö','Oe')
    newValue = newValue.replace('Ü','Ue')
    newValue = newValue.replace('ß','ss')
    # replace all other special characters
    # normalise, i. e. replace e.g. é with e
    newValue = unicodedata.normalize('NFKD', newValue).encode('ascii', 'ignore')
    newValue = newValue.decode('utf-8')
    # some custom rules to serve as example
#    newValue = newValue.replace(', ','_')
#    newValue = newValue.replace(',','_')
#    newValue = newValue.replace('+','_')
#    newValue = newValue.replace(' - ','-')
#    newValue = newValue.replace(' ','_')
    # you can also use regular expressions e. g.:
    # newValue = str(re.sub(r'(\()([\d]\))', r'-\2', newValue))
    # '( one number )' becomes '-number)'

    # all remaining invalid characters are removed
    # \ and / are kept to keep the path
    newValue = str(re.sub('[^a-zA-Z0-9_\-/\\\]', '', newValue))

    return newValue+fileExt


if __name__=="__main__":
    # set path to facs files
    path_facs = u'./data/facs/*_image_name.xml'
    # rename facs files
    for file in glob.glob(path_facs):
        with open (file, 'r', encoding='utf-8') as f:
            tree = ET.parse(f)
            root = tree.getroot()
            for elem in root.iter('item'):
                image_name = elem.text
                image_name = normaliseName(image_name)
                elem.text = image_name
            tree.write(file, encoding='utf-8', xml_declaration=True)
    print('Done')