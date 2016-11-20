module Jekyll
  class MultiPageGenerator < Generator
    def generate(site)
      post_subposts = []
      
      site.posts.docs.each_with_index do |post|
        # Split post content into multiple pages with nextpage tag
        subposts = post.content.split('<!--nextpage-->')
        
        # When we indeed have more than one page
        if subposts.size > 1
          # Replace content of the original post with first page content
          post.content = subposts[0]
          
          # Generate the rest of the pages
          subposts.shift
          subposts.map!.with_index do |content, index|
            subpost = Document.new post.path, {site: site, collection: site.collections["subposts"]}
            subpost.content = content
            ["tags", "categories", "contributor", "date", "layout", "dsq_thread_id"].each do |prop|
              subpost.data[prop] = post.data[prop]
            end
            subpost.data["permalink"] = File.join(post.permalink, (index + 2).to_s, "/")
            subpost.data["title"]     = "#{post.data["title"]} <span>Trang #{index + 2}</span>"
            subpost.data["excerpt"]   = Excerpt.new(subpost).to_s
            
            subpost
          end
          
          # Tell Jekyll to produce our generated pages
          site.collections["subposts"].docs.push *subposts
          
          # Store metadata to actually produce links in template
          subposts.unshift post
          subposts.each.with_index do |subpost, index|
            subpost.data["subpost_index"] = index
            subpost.data["subposts"] = subposts
          end
        end
      end
    end
  end
end
