xdescribe PageHub::Markdown::Embedder do
  Markdown = PageHub::Markdown
  before do
    Markdown.configure
    subject.stub(:get_resource).and_return('')
  end

  after  { Markdown.reset_config }

  GitHubPageURI = {
    "https://github.com/amireh/pagehub-markdown/wiki/Github-embedding-test" => <<-EOF
      <p>I'm embedded from a <a href="https://github.com/amireh/pagehub-markdown/wiki/GitHub-embedding-test">GitHub wiki page</a>!</p>
    EOF
    .strip
  }

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

    GitHubPageURI.each_pair { |uri, content|
      Markdown.render!(strip %Q<
        [!include github-wiki!](#{uri})
      >).should match strip content
    }

  end

  it "should embed a GitHub wiki page implicitly via URL" do
    GitHubPageURI.each_pair { |uri, content|
      Markdown.render!(strip %Q<
        [!include!](#{uri})
      >).should match strip content
    }
  end

  it "should escape nested embeddings" do
    Markdown.render! strip(<<-EOF
      [!include github-wiki!](https://github.com/amireh/pagehub-markdown/wiki/Recursive-embedding-test)
    EOF
    ).should match strip(
    <<-EOF
      See this indirectly embedded resource from
    EOF
    )
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