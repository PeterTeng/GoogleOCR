#! /usr/bin/env ruby

require 'json'
require 'google/apis/vision_v1'
require 'dotenv'

# Load .env
Dotenv.load

Vision = Google::Apis::VisionV1
vision = Vision::VisionService.new

# NOTE(peter) - Please add your api key in .env file
vision.key = ENV['GOOGLE_PRIVATE_KEY']

# Get arguments from prompt
@filename = ARGV[0]
@keyword = ARGV[1]

# Set colors for output
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def blue
    colorize(36)
  end
end

# Check if filename argument provided
def filename_exist?
  if @filename
    true
  else
    puts "You need to provide a image file"
    puts "For example: "
    puts "ruby main.ruby test.png"
    false
  end
end

# Set request with type and filename
def request_with_type_and_filename(type, filename)
  Google::Apis::VisionV1::BatchAnnotateImagesRequest.new(
    requests: [
      {
        image:{
          content: File.read(filename)
        },
        features: [
          {
            type: "#{type}",
            maxResults: 1
          }
        ]
      }
    ]
  )
end

if filename_exist?
  request = request_with_type_and_filename("TEXT_DETECTION", @filename)

  vision.annotate_image(request) do |result, err |
    unless err then
      result.responses.each do | res |
        detected_text = res.text_annotations[0].description
        locale = res.text_annotations[0].locale
        puts "\nDetected Language : #{locale}".blue
        puts "\nText detected in #{@filename} :".blue
        puts detected_text
        puts "\nTotal text count = #{detected_text.length}".blue
        if @keyword
          puts "Text includes >> #{@keyword}" if detected_text.include? @keyword
        end
      end
    else
      puts err
    end
  end
end
