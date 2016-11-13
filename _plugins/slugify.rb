module Jekyll
  module Utils
    extend self
    
    alias_method :old_slugify, :slugify
    
    def slugify(string, mode: nil, cased: false)
      old_slugify(string, mode: mode, cased: cased).to_url
    end
  end
end
