import os
import re

DEFAULT_EXT = '.html'

IF='if'
ENDIF='endif'
ELSE = 'else'

class IfEntry:
	def __init__(self,_start,_end,_type,_dict_key):
		self.start = _start
		self.end = _end
		self.type = _type
		self.dict_key = _dict_key

	def isIf(self):
		return IF==self.type

	def isEndIf(self):
		return ENDIF==self.type

	def isElse(self):
		return ELSE==self.type

class Preprocessor:
	"""docstring for Preprocessor"""
	def __init__(self, tpl_dir):
		self.tpl_dir = tpl_dir

	def _tpl_for_name(self,tpl_name):
		path = self._path_for_tpl_name(tpl_name)
		if not os.access(path,os.F_OK):
			path=path+DEFAULT_EXT
		f = open(path)
		content = f.read()
		f.close()
		return content

	def _path_for_tpl_name(self,tpl_name):
		return os.path.join(self.tpl_dir,tpl_name)

	def process_tpl_name_with_dict(self,tpl_name,dict):
		content = self._tpl_for_name(tpl_name)
		return self.process_content_with_dict(content,dict)

	def process_content_with_dict(self,content,dict):
		content = self._loop_process(self._replace_includes,content,dict)
		content = self._loop_process(self._replace_ifs,content,dict)
		content = self._replace_variables(content,dict)
		return content

	def _loop_process(self,func,content,dict):
		while True:
			content,has_more = func(content,dict)
			if not has_more:
				break;
		return content

	def _replace_includes(self,content,dict):
		result = False
		m = re.search('%include ([^%]*)%',content)
		if m:
			include_name = m.group(1)
			include_content = self._tpl_for_name(include_name)
			content = content.replace(m.group(0),include_content)
			result = True
		return content,result

	def _replace_ifs(self,content,dict):
		result = False
		ifs_iter = re.finditer('%if ([^%]*)%',content)
		else_iter = re.finditer('%else%',content)
		endifs_iter = re.finditer('%endif%',content)

		ifs_list = []
		for m in ifs_iter:
			ifs_list.append(IfEntry(m.start(),m.end(),IF,m.group(1)))

		for m in else_iter:
			ifs_list.append(IfEntry(m.start(),m.end(),ELSE,''))

		for m in endifs_iter:
			ifs_list.append(IfEntry(m.start(),m.end(),ENDIF,''))

		ifs_list = sorted(ifs_list,key=lambda entry: entry.start)

		if len(ifs_list):
			result = True

		for i,if_e in enumerate(ifs_list):
			if if_e.isIf():
				#find matching else and endif:
				endif = None
				else_ = None
				nested_ifs_count = 0
				for ii,ee in enumerate(ifs_list[i+1:]):
					if ee.isEndIf():
						if nested_ifs_count==0:
							endif = ee
							break
						else:
							nested_ifs_count=nested_ifs_count-1
					elif ee.isIf():
						nested_ifs_count=nested_ifs_count+1
					elif ee.isElse() and nested_ifs_count==0:
						else_ = ee

				if if_e.dict_key in dict and dict[if_e.dict_key]:
					if else_:
						content = content[:else_.start] + content[endif.end:]
					else:
						content = content[:endif.start] + content[endif.end:]

					content = content[:if_e.start] + content[if_e.end:]
				else:
					content = content[:endif.start] + content[endif.end:]

					if else_:
						content = content[:if_e.start]+ content[else_.end:]
					else:
						content = content[:if_e.start]+ content[endif.start:]
				break

		return (content,result)


	def _replace_variables(self,content,dict):
		for k,v in dict.iteritems():
			content = content.replace('%'+k+'%',str(v))
		return content