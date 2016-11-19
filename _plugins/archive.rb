module Jekyll
  class ArchivePage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'archive.html')
      self.data['title'] = "#{category}"
    end
  end
  
  class ArchiveGenerator < Generator
    def generate(site)
      @site = site
      
      # Generate tag archive
      
      # Generate category archive
      site.categories.each do |category, posts|
        pages = paginate(posts, category)
        site.pages.concat pages
      end
      
      # Generate contributor archive
      
      
    end
    
    def paginate(posts, name, type = 'category', base = '/')
      site = @site
      per_page = site.config['paginate']
      paginate_path = site.config['paginate_path']
      slices = posts.each_slice(per_page).to_a
      total_pages = slices.size
      
      slices.each_with_index.map do |per_page_posts, index|
        base_url = File.join(base, Utils.slugify(name))
        current_url = base_url
        previous_url = nil
        next_url = nil
        current_page = index + 1
        
        if current_page > 1
          current_url = File.join(base_url, paginate_path.sub(':num', current_page.to_s))
        
          if current_page == 2
            previous_url = base_url
          else
            previous_url = File.join(base_url, paginate_path.sub(':num', (current_page - 1).to_s))
          end
        end
        
        if current_page < total_pages
          next_url = File.join(base_url, paginate_path.sub(':num', (current_page + 1).to_s))
        end
        
        page = ArchivePage.new(site, site.source, current_url, name)
        page.data['paginator'] = {
          "page" => index + 1,
          "per_page" => per_page,
          "posts" => per_page_posts,
          "total_posts" => posts.size,
          "total_pages" => slices.size,
          "previous_page" => current_page > 1 ? current_page - 1 : nil,
          "previous_page_path" => previous_url,
          "next_page" => current_page < total_pages ? current_page + 1 : nil,
          "next_page_path" => next_url
        }
        page.data['archive_type'] = type
        
        page
      end
    end
  end
end
