module Jekyll
  class DisqusPage < Page
    def initialize(site, base, post)
      @site = site
      @base = base
      @dir = File.join('disqus', post.data['dsq_thread_id'])
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_includes'), 'disqus.html')
      self.data['related_page'] = post
      self.data['title'] = post.data['title']
      self.data['dsq_thread_id'] = post.data['dsq_thread_id']
      self.data['dsq_url'] = post.data['permalink']
    end
  end

  class DisqusPageGenerator < Generator
    safe true

    def generate(site)
      site.posts.docs.each do |post|
        if post.data['dsq_thread_id'].length > 0
          site.pages << DisqusPage.new(site, site.source, post)
        end
      end
    end
  end
end
