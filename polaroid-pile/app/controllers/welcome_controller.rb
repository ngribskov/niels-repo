class WelcomeController < ApplicationController
  def index
    dir = "./app/assets/images"
    num_of_files = Dir[File.join(dir,"**","*")].count{|file| File.file?(file)}
    @array_of_photos = []
    1.upto(num_of_files) do |i|
      if i < 10
        id = "00#{i}"
      elsif i < 100
        id = "0#{i}"
      else
        id = i
      end
      random_orientation = rand(1..360)
      random_x = rand(1..100) - 10
      random_y = rand(1..100) - 10
      @array_of_photos.push([random_orientation,random_x,random_y,id])
    end
    @array_of_photos.reverse
  end
end
