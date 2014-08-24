module PageHub
module Markdown
  module ToC
    FENCED_CODE_BLOCKS = /```[^`]+```/xm

    # Builds a tree of headings from a given block of Markdown
    # text, the returned list can be turned into HTML using
    # ToC::to_html()
    def self.from_markdown(markdown, threshold = 6)
      self.from_content(/(#+)\s([^\n]+)/, lambda { |l, t| return l.length, t }, markdown, threshold)
    end

    # renders a table of content using nested <ol> list nodes
    # from a given list of Heading objects produced by ToC::from_markdown()
    def self.to_html(toc)
      html = "<ol>"
      toc.each { |heading| html << heading.to_html }
      html << "</ol>"
      html
    end

    private

    def self.from_content(pattern, formatter, content, threshold)
      headings  = []
      current   = []
      toc_index = 0
      content.gsub(FENCED_CODE_BLOCKS, '').scan(pattern).each { |l, t|
        level,title = formatter.call(l, t)

        if level <= threshold
          h = Heading.new(title, level, toc_index)
          headings << h
          current[level] = h
          toc_index += 1 # toc_index is used for hyperlinking

          # if there's a parent, attach this heading as a child to it
          if current[level-1] then
            current[level-1] << h
          end
        end
      }

      toc = []
      headings.each { |h|
        next if h.parent
        toc << h
      }

      toc
    end

    class Heading
      attr_accessor :level, :title, :children, :parent, :index

      def initialize(title, level, index)
        @title = title
        @level = level
        @index = index
        @parent = nil
        @children = []
        super()
      end

      def <<(h)
        @children.each { |child|
          return if child.title == h.title
        }

        h.parent = self
        @children << h
      end

      def to_html()
        html = ""
        html << "<li>"
        html << "<a href=\"\##{header_anchor(title)}\">" << title << "</a>"

        if children.any? then
          html << "<ol>"
          children.each { |child| html << child.to_html }
          html << "</ol>"
        end

        html << "</li>"
      end

      private

      def header_anchor(title)
        CGI.escapeHTML(title.downcase.gsub(/\s+/, '-'))
      end
    end
  end

  # register the processor
  add_processor :pre_render, lambda { |str|
    str.gsub!(/^\B\[\!toc(.*)\!\]/) {
      ToC.to_html ToC.from_markdown(str, $1.empty? ? 6 : $1.strip.to_i)
    }
    str
  }

end # Markdown module
end # PageHub module