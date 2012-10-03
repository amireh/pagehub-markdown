module PageHub
module Markdown

  describe "Processor: Embedder" do

    before do
      Markdown.configure()
    end

    it "should raise a timeout error" do
      Markdown.render!(strip <<-EOF
        [!include!](http://localhost:1212/some-non-existent.txt)
      EOF
      ).should match(/Embedding error/)
    end

    it "should raise a bad filetype error" do
      Markdown.render!(strip <<-EOF
        [!include!](http://www.pagehub.org/favicon.ico)
      EOF
      ).should match(/the file type you tried to embed .* is not supported/)
    end

    it "should embed a GitHub wiki page" do

      raw = strip <<-EOF
        [!include github-wiki!](https://github.com/amireh/pagehub/wiki/PageHub-embedding-test)
      EOF

      rendered = Markdown.render! raw

      strip(rendered).should match strip <<-EOF
        <p>I'm embedded from a <a href="https://github.com/amireh/pagehub/wiki/PageHub-embedding-test">GitHub wiki page</a>!</p>
      EOF
    end

    it "should embed a GitHub wiki page implicitly via URL" do

      raw = strip <<-EOF
        [!include!](https://github.com/amireh/pagehub/wiki/PageHub-embedding-test)
      EOF

      rendered = Markdown.render! raw

      strip(rendered).should match strip <<-EOF
        <p>I'm embedded from a <a href="https://github.com/amireh/pagehub/wiki/PageHub-embedding-test">GitHub wiki page</a>!</p>
      EOF
    end

    it "should embed a PageHub page" do

      uri = 'http://pagehub.org/pagehub/embed-me'

      raw = strip <<-EOF
        [!include pagehub!](#{uri})
      EOF

      rendered = Markdown.render! raw

      strip(rendered).should match strip <<-EOF
        <p>I'm embedded from <a href="www.pagehub.org">PageHub</a>!</p>
      EOF
    end

  end

end
end