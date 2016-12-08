#! /usr/bin/env ruby

require 'json'
require 'google/apis/vision_v1'
require 'dotenv'

Dotenv.load

Vision = Google::Apis::VisionV1
vision = Vision::VisionService.new

# NOTE(peter) - Please add your api key in .env file
vision.key = ENV['GOOGLE_PRIVATE_KEY']

filename = ARGV[0]
keyword = ARGV[1]

request = Google::Apis::VisionV1::BatchAnnotateImagesRequest.new(
  requests: [
    {
      image:{
        content: File.read(filename)
      },
      features: [
        {
          type: "TEXT_DETECTION",
          maxResults: 1
        }
      ]
    }
  ]
)

vision.annotate_image(request) do |result, err |
  unless err then
    result.responses.each do | res |
      detected_text = res.text_annotations[0].description
      puts "\nText detected in #{filename} :"
      puts detected_text
      puts "\nTotal text count = #{detected_text.length}"
      if keyword
        puts "Text includes >> #{keyword}" if detected_text.include? keyword
      end
    end
  else
    puts err
  end
end
