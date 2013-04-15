import unittest
import os
from Preprocessor import Preprocessor

class TestPreprocessor(unittest.TestCase):
	def setUp(self):
		cur_dir = os.path.dirname(os.path.realpath(__file__))
		self.tpl_dir = os.path.join(cur_dir,'..','UnitTests','test_templates')
		self.preprocessor = Preprocessor(self.tpl_dir)

	def process_content(self,content,dict,expected):
		actual = self.preprocessor.process_content_with_dict(content,dict)
		self.assertEqual(actual,expected)

	def test_ifs(self):
		dict = {'basic_key':'_trivial_', 'yes_key':True, 'no_key':False}
		self.process_content("basic%basic_key%basic",dict,"basic_trivial_basic")
		self.process_content("%if yes_key%%basic_key%%endif%",dict,"_trivial_")
		self.process_content("%if no_key%%basic_key%%endif%",dict,"")
		self.process_content("aa%if yes_key%%if no_key%%basic_key%%endif%%endif%bb",dict,"aabb")
		self.process_content("start %if non_existant_key%non_existant%endif% finish",dict,"start  finish")
		self.process_content("start %if non_existant_key%%if yes_key%%basic_key%%endif%%endif% finish",dict,"start  finish")
		self.process_content("start %if yes_key%yes%else%no%endif%",dict,"start yes")
		self.process_content("start %if no_key%yes%else%no%endif%",dict,"start no")
		self.process_content("start %if non_existant_key%yes%else%non_exist%endif%",dict,"start non_exist")

		self.process_content("%if yes_key%%if no_key%yes%else%no%endif%%endif%",dict,"no")
		self.process_content("%if no_key% hello1 %else% %if yes_key% hello2 %else% hello3 %endif% %endif%",dict,"  hello2  ")


	def test_includes(self):
		content = self.preprocessor.process_tpl_name_with_dict('test_include',{'a':True,'aa':'a'})
		self.assertEqual(content,'<html><body> a </body></html>')


if __name__ == '__main__':
	unittest.main()