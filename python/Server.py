#!/usr/bin/python
import sys
import os
from BaseHTTPServer import HTTPServer
from SimpleHTTPServer import SimpleHTTPRequestHandler
from Preprocessor import Preprocessor

class TemplateRenderingRequestHandler(SimpleHTTPRequestHandler):
	def do_GET(self):
		dict_by_path = {
			'/pasteboard.html': {
				'PasteboardShare':True,
				'PasteboardShare_details':'text',
				'TextShare_details':'text',
				'PicturesShare_details':'0 albums',
				'show_link_text':True,
				'show_link_pictures':True,
				'is_shared':True
				},
			'/text.html' : {
				'TextShare':True,
				'TextShare_details':'text',
				'PasteboardShare_details':'text',
				'TextShare_details':'text',
				'PicturesShare_details':'0 albums',
				'show_link_pasteboard':True,
				'show_link_pictures':True,
				'is_shared':True
				},
			'/pictures.html': {
				'PicturesShare':True,
				'PasteboardShare_details':'text',
				'TextShare_details':'text',
				'PicturesShare_details':'0 albums',
				'show_link_text':True,
				'show_link_pasteboard':True,
				'is_shared':True,
				'album_list_html_block':self.album_list_html_block()
				},
			'/album.html': {
				'AlbumShare':True,
				'PasteboardShare_details':'text',
				'TextShare_details':'text',
				'PicturesShare_details':'0 albums',
				'show_link_text':True,
				'show_link_pasteboard':True,
				'show_link_pictures':True,
				'is_shared':True,
				'album_name':'My Photos',
				'number_of_pictures':15,
				'pictures_html_block':self.pictures_html_block()
			}
		}

		path = self.path
		if path=='/' or path=='/index.html':
			path = '/pasteboard.html'

		if path in dict_by_path:
			self.send_response(200)
			self.send_header('Content-type','text/html')
			self.end_headers()
			sys.stdout = self.wfile
			print self.preprocessor.process_tpl_name_with_dict('index.html',dict_by_path[path])
		else:
			SimpleHTTPRequestHandler.do_GET(self)

	def album_list_html_block(self):
		albums_preprocessor = Preprocessor(tpl_dir)
		dict = {
				'number_of_pictures':152,
				'album_name':'My Photos',
				'album_share_href':'/album.html',
				'img_width_t':150,
				'img_height_t':150,
				'poster_image_src':'/test_image.jpeg'
			}
		text = ''
		for i in xrange(1,4):
			text = text + albums_preprocessor.process_tpl_name_with_dict('album_list_item',dict)
		return text

	def pictures_html_block(self):
		pictures_preprocessor = Preprocessor(tpl_dir)
		dict = {
				'img_size_l':'1836x2448',
				'img_size_m':'1224x1632',
				'img_size_s':'612x816',
				'img_width_t':150,
				'img_height_t':150,
			}

		text = ''
		for i in xrange(1,16):
			text = text + pictures_preprocessor.process_tpl_name_with_dict('asset',dict)
		return text

if sys.argv[1:]:
    port = int(sys.argv[1])
else:
	port = 8000
	
server_address = ('127.0.0.1', port)
cur_dir = os.path.dirname(os.path.realpath(__file__))
tpl_dir = os.path.join(cur_dir,'..','Finch','res','tpl')
doc_root_dir = os.path.join(cur_dir,'..','Finch','res','docroot')
os.chdir(doc_root_dir)

TemplateRenderingRequestHandler.preprocessor = Preprocessor(tpl_dir)
TemplateRenderingRequestHandler.protocol_version = "HTTP/1.0"
httpd = HTTPServer(server_address, TemplateRenderingRequestHandler)

sa = httpd.socket.getsockname()
print "Serving HTTP on", sa[0], "port", sa[1], "..."


httpd.serve_forever()