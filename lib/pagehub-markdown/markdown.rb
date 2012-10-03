module PageHub
  module Markdown

    class << self
      def add_processor(stage, p) # :nodoc:
        Stages.each { |s| @@hooks[s] ||= [] }

        unless Stages.include?(stage.to_sym)
          raise "Invalid stage #{stage}. Allowed stages are #{Stages.join(', ')}"
        end

        unless p.respond_to?(:call)
          raise "Processor must be a callable object."
        end

        if stage.is_a? Array
          stage.each { |s| @@hooks[s] << p }
        else
          @@hooks[stage.to_sym] << p
        end

      end

      def add_mutator(m) # :nodoc:
        unless m.respond_to?(:call)
          raise "Mutator must be a callable object."
        end

        @@mutators << m
      end

      # (re)constructs the renderer with the given options, see
      # PageHubOptions, RendererOptions, and RendererExtensions
      # for accepted values
      def configure(ph_options = {}, options = {}, extensions = {})
        @@options  = PageHubOptions.merge(ph_options)

        @@renderer = Redcarpet::Markdown.new(
          HTMLWithAlbino.new(RendererOptions.merge(options)),
          RendererExtensions.merge(extensions))
      end

      def render!(str)
        configure unless @@renderer

        @@hooks[:pre_render].each { |processor| processor.call(str) }

        # escape any JavaScript snippets
        if @@options[:escape_scripts]
          str.gsub!(/\<script(.*)\>/i) {
            mutated = true
            "&lt;script#{$1}&gt;"
          }
        end

        str = @@renderer.render(str)

        @@hooks[:post_render].each { |processor| processor.call(str) }

        str
      end

      def render(str)
        o = str.dup; render!(o); o
      end

      def mutate!(str)
        mutated = false
        @@mutators.each { |m| mutated ||= m.call(str) }
        mutated
      end

    end

    protected

    Stages      = [ :pre_render, :post_render ]
    @@hooks     = { }
    @@mutators  = [ ]
    @@options   = { }

    PageHubOptions = {
      escape_scripts:   true
    }

    RendererOptions = {
      filter_html:      false,
      no_images:        false,
      no_links:         false,
      no_styles:        false,
      safe_links_only:  false,
      with_toc_data:    true,
      hard_wrap:        false,
      xhtml:            false
    }

    RendererExtensions = {
      no_intra_emphasis:    true,
      tables:               false,
      fenced_code_blocks:   true,
      autolink:             true,
      strikethrough:        true,
      lax_html_blocks:      false,
      space_after_headers:  true,
      superscript:          true
    }

    private

    # a renderer that uses Albino to highlight syntax
    class HTMLWithAlbino < Redcarpet::Render::HTML
      def block_code(code, language)
        begin
          # TODO: try to figure out whether @language is valid
          out = Albino.colorize(code, language)
        rescue Exception => e
          out = ""
          # return "-- INVALID CODE BLOCK, MAKE SURE YOU'VE SURROUNDED CODE WITH ```"
        end

        # just render the code as plain text if the language is invalid
        out.empty? ? block_code(code, "text") : out
      end
    end

    @@renderer = nil
  end
end