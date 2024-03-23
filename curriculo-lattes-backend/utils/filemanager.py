import os
import xmltodict

def getAllXMlNames(dirPath = ''):
    return os.listdir(dirPath)

def readXML(xmlFilePath = ''):
    file = open(xmlFilePath, encoding='latin-1')
    file_string = file.read()
    file.close()
    return xmltodict.parse(file_string)

print(readXML('../assets/xml/0023809873085852.xml')['CURRICULO-VITAE']['@SISTEMA-ORIGEM-XML'])