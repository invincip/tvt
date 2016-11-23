require 'stringex_lite'

module Jekyll
  module CustomFilter
    def wpautop(pee, br = true)
      return '' if pee.strip == ''
      allblocks = '(?:table|thead|tfoot|caption|col|colgroup|tbody|tr|td|th|div|dl|dd|dt|ul|ol|li|pre|select|option|form|map|area|blockquote|address|math|style|p|h[1-6]|hr|fieldset|noscript|legend|section|article|aside|hgroup|header|footer|nav|figure|figcaption|details|menu|summary)'
      pre_tags = {}
      pee = pee + "\n"
      if pee.include?('<pre')
        pee_parts = pee.split('</pre>')
        last_pee = pee_parts.pop
        pee = ''
        pee_parts.each_with_index do |pee_part, i|
          start = pee_part.index('<pre')
          unless start
            pee += pee_part
            next
          end
          name = "<pre wp-pre-tag-#{i}></pre>"
          pre_tags[name] = pee_part[start..-1] + '</pre>'
          pee += pee_part[0, start] + name
        end
        pee += last_pee
      end
      pee = pee.gsub(Regexp.new('<br />\s*<br />'), "\n\n")
      pee = pee.gsub(Regexp.new("(<" + allblocks + "[^>]*>)"), "\n\\1")
      pee = pee.gsub(Regexp.new("(</" + allblocks + ">)"), "\\1\n\n")
      pee = pee.gsub("\r\n", "\n").gsub("\r", "\n")
      if pee.include? '<object'
        pee = pee.gsub(Regexp.new('\s*<param([^>]*)>\s*'), "<param\\1>")
        pee = pee.gsub(Regexp.new('\s*</embed>\s*'), '</embed>')
      end
      pees = pee.split(/\n\s*\n/).compact
      pee = ''
      pees.each { |tinkle| pee += '<p>' + tinkle.chomp("\n") + "</p>\n" }
      pee = pee.gsub(Regexp.new('<p>\s*</p>'), '')
      pee = pee.gsub(Regexp.new('<p>([^<]+)</(div|address|form)>'), "<p>\\1</p></\\2>")
      pee = pee.gsub(Regexp.new('<p>\s*(</?' + allblocks + '[^>]*>)\s*</p>'), "\\1")
      pee = pee.gsub(Regexp.new('<p>(<li.+?)</p>'), "\\1")
      pee = pee.gsub(Regexp.new('<p><blockquote([^>]*)>', 'i'), "<blockquote\\1><p>")
      pee = pee.gsub('</blockquote></p>', '</p></blockquote>')
      pee = pee.gsub(Regexp.new('<p>\s*(</?' + allblocks + '[^>]*>)'), "\\1")
      pee = pee.gsub(Regexp.new('(</?' + allblocks + '[^>]*>)\s*</p>'), "\\1")
      if br
        pee = pee.gsub(Regexp.new('<(script|style).*?</\1>')) { |match| match.gsub("\n", "<WPPreserveNewline />") }
        pee = pee.gsub(Regexp.new('(?<!<br />)\s*\n'), "<br />\n")
        pee = pee.gsub('<WPPreserveNewline />', "\n")
      end
      pee = pee.gsub(Regexp.new('(</?' + allblocks + '[^>]*>)\s*<br />'), "\\1")
      pee = pee.gsub(Regexp.new('<br />(\s*</?(?:p|li|div|dl|dd|dt|th|pre|td|ul|ol)[^>]*>)'), "\\1")
      pee = pee.gsub(Regexp.new('\n</p>$'), '</p>')
      pre_tags.each do |name, value|
        pee.gsub!(name, value)
      end
      pee
    end
  
    def to_url(string)
      string.to_url
    end
    
    def active_then_set_current(url, menu_item)
        current_menu = '/'
        case
        when url.start_with?('/truyen-dai')
            current_menu = 'truyen-dai'
        when url.start_with?('/truyen-ngan')
            current_menu = 'truyen-ngan'
        when url.start_with?('/one-shot')
            current_menu = 'one-shot'
        when url.start_with?('/manga')
            current_menu = 'manga'
        when url.start_with?('/tim-kiem')
            current_menu = 'tim-kiem'
        end
        if current_menu == menu_item
          'current-menu-item'
        end
    end
    
    def pagination(posts, current_index)
      html = ''
      current_page = current_index + 1
      total_pages = posts.size
      
      if total_pages == 1
        return html
      end

      if current_page > 1
        html << "<a class='prev' href='#{posts[current_index - 1].permalink}'>Trước</a>"
      end
      
      if current_page == 1
        html << "<a class='current' href='#{posts[0].permalink}'>1</a>"
      else
        html << "<a href='#{posts[0].permalink}'>1</a>"
      end

      if total_pages > 3 && current_page > 3
        html << "<span>...</span>"
      end
      
      if current_page > 2
        if current_page == total_pages and total_pages > 3
          html << "<a href='#{posts[current_index-2].permalink}'>#{current_page - 2}</a>"
        end
        html << "<a href='#{posts[current_index-1].permalink}'>#{current_page - 1}</a>"
      end

      if current_page != 1 and current_page != total_pages
        html << "<a class='current' href='#{posts[current_index].permalink}'>#{current_page}</a>"
      end

      if current_page < total_pages - 1
        html << "<a href='#{posts[current_index+1].permalink}'>#{current_page+1}</a>"
        if current_page == 1 and total_pages > 3
          html << "<a href='#{posts[current_index+2].permalink}'>#{current_page+2}</a>"
        end
      end
      
      if total_pages > 3 && current_page < total_pages - 2
        html << "<span>...</span>"
      end

      if current_page == total_pages
        html << "<a class='current' href='#{posts[total_pages-1].permalink}'>#{total_pages}</a>"
      else
        html << "<a href='#{posts[total_pages-1].permalink}'>#{total_pages}</a>"
      end

      if current_page < total_pages
        html << "<a class='next' href='#{posts[current_index+1].permalink}'>Tiếp</a>"
      end
      
      html
    end
  
    def first_half(array)
        array[0, array.size / 2]
    end
    
    def second_half(array)
        array[-array.size / 2, array.size]
    end
    
    def random(array, num)
      array.sample(num)
    end
    
    # Add thousand separator to number
    def number(num)
      num.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    end
    
    def min(num, minimum)
      if num < minimum
        minimum
      else
        num
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::CustomFilter)
