require 'webrick'

root = '/'

server = WEBrick::HTTPServer.new(:Port => 8080)
trap('INT') {server.shutdown}

server.mount_proc(root) do |req, res|
  res.content_type=('text/text')
  res.body = req.path
end



server.start