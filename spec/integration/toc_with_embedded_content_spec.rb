module PageHub
module Markdown

  xdescribe "Embedded content with a Table of Content" do

    before do
      Markdown.configure()
    end

    it "should build a ToC only for the original content" do

      raw = strip <<-EOF
        [!toc!]

        # My Embedding Test

        [!include pagehub!](http://www.pagehub.org/pagehub-editor/embed-test-with-headings)
      EOF

      rendered = Markdown.render! raw

      html_strip(rendered).should eq strip <<-EOF
        <ol class=\"table-of-contents\"><li><a href="#toc_0">My Embedding Test</a></li></ol>
        <h1 id="toc_0">My Embedding Test</h1>
        <div data-embed-uri="http://www.pagehub.org/pagehub-editor/embed-test-with-headings" data-embed-src="pagehub">
        <h1>Food</h1>
        <h2>Fruit</h2>
        <h2>Veggies</h2>
        <h3>Lettuce</h3>
        <h1>Animals</h1>
        </div>
      EOF
    end

  end

end
end