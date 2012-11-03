require_relative 'batch'
require_relative 'proofsheet'

module Proofcheater
  class Runner

    def initialize

      # You can define batch details using a hash...
      #
      # input = { :album_name => "Test",
      #           :source_directory => "/Users/joshmejia/Desktop/Proofsheets/source",
      #           :destination_directory => "/Users/joshmejia/Desktop/Proofsheets/destination",
      #           :page_number => "25",
      #           :client_logo => "/Users/joshmejia/Pictures/client-logo.jpg",
      #           :contact_info => "/Users/joshmejia/Pictures/contact-info-and-logo.jpg",
      #           :date => "November 2012",
      #           :header_left_bottom => "Photographer Name",
      #           :event => "Product Photoshoot",
      #           :notes => "Image size, Usage rights",
      #          }

      # Or define batch details using a step by step prompt through the terminal

      input = Hash.new
      puts "\nWhat is the album name?"
      input[:album_name] = gets.strip!

      puts "\nDrag the SOURCE DIRECTORY to the Terminal window and hit RETURN."
      input[:source_directory] = gets.strip!

      puts "\nDrag the DESTINATION DIRECTORY to the Terminal and hit RETURN."
      input[:destination_directory] = gets.strip!

      puts "\nEnter the starting page number."
      input[:page_number] = gets.strip!

      puts "\nEnter the path to the client logo."
      input[:client_logo] = gets.strip!

      puts "\nEnter the path to your company logo or contact information."
      input[:contact_info] = gets.strip!

      puts "\nWhat is the date of the photoshoot?"
      input[:date] = gets.strip!

      puts "\nAdditional info to add to the left-bottom of the header."
      input[:header_left_bottom] = gets.strip!

      puts "\nWhat is the event name?"
      input[:event] = gets.strip!

      puts "\nEnter additional notes."
      input[:notes] = gets.strip!

      @batch = Proofcheater::Batch.new(input)
    end

    def run
      puts "\nYour proof sheets are being generated..."
      @batch.create_directories
      @batch.create_subdirectories
      @batch.copy_images
      @batch.create_tmp_image_list
      proofsheet = Proofsheet.new(@batch)
      proofsheet.create
      @batch.remove_tmp
      puts "\nProof sheets and organized images can be found in #{@batch.destination_directory}"
    end
  end
end
