require 'rubygems'
require 'rest_client'
module YmTools::Command
  class Noun < Base
    def index
      noun = args[0].to_i
      print "Downloading zipped SVG for noun #{'%3d' % noun}........"
      system("mkdir -p ~/Pictures/nouns/tmp")
      system("curl -sL http://thenounproject.com/download/zipped/svg_#{noun}.zip -o ~/Pictures/nouns/tmp/svg_#{noun}.zip")
      puts "COMPLETE"
      
      print "Unzipping zipped SVG......................."
      system("unzip -q ~/Pictures/nouns/tmp/svg_#{noun}.zip -d ~/Pictures/nouns/tmp")
      puts "COMPLETE"

      print "Sending for conversion to PNG.............."
      res = RestClient.post('http://www.fileformat.info/convert/image/svg2raster.htm', :stdin => File.new("#{ENV['HOME']}/Pictures/nouns/tmp/noun_project_#{noun}.svg"), :target_png => 'png')
      puts "COMPLETE"

      print "Downloading PNG............................"
      png_path = res.match(/\/user\/anonymous\/download\/\w*\/svg2raster\.png/)[0]
      system("curl -s http://www.fileformat.info#{png_path} -o ~/Pictures/nouns/#{noun}.png")
      puts "COMPLETE"

      system("rm -rf #{ENV['HOME']}/Pictures/nouns/tmp")
      system("open #{ENV['HOME']}/Pictures/nouns")
      system("open #{ENV['HOME']}/Pictures/nouns/#{noun}.png")
    end
  end
end


