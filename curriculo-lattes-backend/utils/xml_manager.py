import os
import xmltodict

class XmlManager:
    def __init__(self, xml_base_directory = ''):
        self.xml_base_directory = xml_base_directory

    def get_all_xml_names(self):
        return os.listdir(self.xml_base_directory)

    def read_xml_in_base_directory(self, xml_file_name = ''):
        return self.read_xml(os.path.join(self.xml_base_directory, xml_file_name))

    def read_xml(self, xml_file_path = ''):
        file = open(xml_file_path, encoding='latin-1')
        file_string = file.read()
        file.close()
        return xmltodict.parse(file_string)
