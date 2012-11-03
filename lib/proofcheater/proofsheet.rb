require 'fileutils'
require 'rubygems'
require 'prawn'
require_relative 'batch'

module Proofcheater
  class Proofsheet

    def initialize(batch)
      @left_column = 0
      @image_number = 1
      @row_height = 175
      @column_width = 220
      @font_size = 9
      @page_number = batch.page_number.to_i
      @batch = batch
    end

    def create
      FileUtils.cd(@batch.destination_directory)
      Prawn::Document.generate("#{@batch.album_name.tr(" ", "_")}_#{@batch.page_number}.pdf",
        :page_layout   => :landscape,
        :left_margin   => 35,
        :right_margin  => 82,
        :top_margin    => 0,
        :bottom_margin => 48,
        :width         => 792,
        :height        => 612
      ) do |pdf|

        @batch.tmp_images.each_slice(9) do |page_images| # divide images into groups of 9 for each page

          # create heading information

          pdf.bounding_box([0, pdf.bounds.top], :width => 160, :height => 68) do
            pdf.pad_top(40) { pdf.text "Date: #{@batch.date}", :size => @font_size, :style => :bold}
            pdf.text @batch.header_left_bottom, :size => @font_size, :style => :bold
          end

          pdf.bounding_box([140, pdf.bounds.top], :width => 210, :height => 68) do
            pdf.pad_top(40) { pdf.text "#{@batch.album_name}-#{"%03d" % @page_number.to_s}", :size => 17, :style => :bold }
          end

          pdf.bounding_box([400, pdf.bounds.top], :width =>260, :height => 68) do
            pdf.pad_top(20) { pdf.image @batch.client_logo, :fit => [140, 40] }
          end

          pdf.bounding_box([620, pdf.bounds.top], :width => 160, :height => 68) do
            pdf.pad_top(40) { pdf.text @batch.event, :size => @font_size, :style => :bold }
            pdf.text @batch.notes, :size => @font_size, :style => :italic
          end

          pdf.bounding_box([pdf.bounds.right, 290], :width =>35, :height => 108) do
            pdf.image @batch.contact_info, :fit => [35, 108]
          end

          page_images.each_slice(3) do |column_images| # divide images into groups of 3 for placement within column
            pdf.bounding_box([@left_column, pdf.bounds.top-70], :width => @column_width, :height => 540) do # create column
              pdf.move_down 80
              column_images.each_with_index do |img, index|
                index += 1
                pdf.bounding_box([0, @row_height*index], :width => @column_width*0.95, :height => @row_height*0.95) do # create box to hold image and number
                  pdf.image "#{@batch.tmp}/#{img}", :fit => [210, @row_height*0.8], :position => :center
                  pdf.pad_top(2) { pdf.text "#{"%02d" % @image_number.to_s}", :style => :bold, :align => :center }
                end
                @image_number += 1
              end
            end
            @left_column += 220 # move to right of page to create new column
          end

          # reset values for new page
          if @image_number.to_i == 10
            @image_number = 1
            @page_number += 1
            @left_column = 0
          end
          pdf.start_new_page
        end

      end # end prawn
    end
  end # end class
end # end module

