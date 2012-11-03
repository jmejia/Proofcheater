require 'rubygems'
require 'fileutils'
require_relative 'attributes'

module Proofcheater
  class Batch < Attributes

    IMAGE_EXTENSIONS = [".jpg", ".jpeg", ".png", ".tif", ".bmp"]
    attr_reader :organizer, :tmp, :tmp_images

    def ignore_unwanted(items)
      items.select { |item| is_image?(item) }
    end

    def is_image?(item)
      IMAGE_EXTENSIONS.include?(File.extname(item).downcase)
    end

    def create_directories
      @organizer = "#{@destination_directory}/organizer"
      @tmp = "#{@destination_directory}/tmp"
      FileUtils.mkdir(@organizer)
      FileUtils.mkdir(@tmp)
    end

    def album_and_page_format(page_number)
      "#{@album_name}_#{"%03d" % page_number}"
    end

    def create_subdirectories
      @original_images = ignore_unwanted(Dir.entries(@source_directory))
      page_number = @page_number.to_i
      directory_count = (@original_images.count.to_f / 9.00).ceil

      directory_count.times do
        FileUtils.mkdir("#{@organizer}/#{album_and_page_format(page_number)}")
        page_number += 1
      end
    end

    def copy_images
      page_number = @page_number.to_i

      @original_images.each_with_index do |image, index|
        image_number = index % 9 + 1
        image_name = "#{album_and_page_format(page_number)}-#{"%02d" % image_number}"
        FileUtils.cp("#{@source_directory}/#{image}", "#{@organizer}/#{album_and_page_format(page_number)}/#{image_name}#{File.extname(image)}")
        system "convert #{@source_directory}/#{image} -strip -define jpeg:extent=1048576 #{@tmp}/#{File.basename(image_name, ".*")}.jpg"
        page_number += 1 if image_number == 9
      end
    end

    def create_tmp_image_list
      @tmp_images = ignore_unwanted(Dir.entries(@tmp))
    end

    def remove_tmp
      FileUtils.rm_rf(@tmp)
    end

  end
end
