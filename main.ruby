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

request = Google::Apis::VisionV1::BatchAnnotateImagesRequest.new(
  requests: [
    {
      image:{
        content: File.read(filename)
      },
      features: [
        {
          type: "TEXT_DETECTION" ,
          maxResults: 1
        }
      ]
    }
  ]
)

vision.annotate_image(request) do |result, err |
  unless err  then
    result.responses.each do | res |
      puts res.text_annotations[0].description
    end
  else
    puts err
  end
end
