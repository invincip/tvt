require 'fastimage'

module Jekyll
  class ThumbnailGenerator < Generator
    def generate(site)
      site.posts.docs.each do |post|
        image_path = File.join('images/posts/' + post.basename_without_ext + '.jpg')
        if File.exists?(image_path)
          size = FastImage.size image_path
          post.data['thumbnail'] = {
            "path" => '/' + image_path,
            "width" => size[0],
            "height" => size[1]
          }
        end
      end
    end
  end
end
