describe PageHub::Markdown::ToC do
  Markdown = PageHub::Markdown
  before { Markdown.configure }
  after  { Markdown.reset_config }

  it "should build a ToC" do

    raw = strip <<-EOF
      [!toc!]

      # Food

      ## Fruit

      ## Veggies

      ### Lettuce

      # Animals
    EOF

    rendered = Markdown.render! raw

    strip(rendered).should match strip <<-EOF
      <ol><li><a href="#food">Food</a><ol><li><a href="#fruit">Fruit</a></li><li><a href="#veggies">Veggies</a><ol><li><a href="#lettuce">Lettuce</a></li></ol></li></ol></li><li><a href="#animals">Animals</a></li></ol>

      <h1 id="food">Food</h1>

      <h2 id="fruit">Fruit</h2>

      <h2 id="veggies">Veggies</h2>

      <h3 id="lettuce">Lettuce</h3>

      <h1 id="animals">Animals</h1>
    EOF
  end

  it "should build an empty ToC" do
    raw = strip <<-EOF
      [!toc!]
    EOF

    rendered = Markdown.render! raw

    strip(rendered).should match strip <<-EOF
      <ol></ol>
    EOF
  end

  it "should ignore stuff in fenced code blocks" do
    raw = strip <<-EOF
      [!toc!]

      # test

      ```coffescript
      # foo
      ```

      ```bash
      # bar
      ```

      # Moving on...

      This should still be included.
    EOF

    rendered = Markdown.render! raw

    strip(rendered).should match strip <<-EOF
      <ol><li><a href="#test">test</a></li><li><a href="#moving-on...">Moving on...</a></li></ol>
    EOF
  end

  it "should generate sanitized anchor ids" do
    str = <<-STR
      # Testing "O(n\\^2)"
    STR
    rendered = Markdown.render! strip(str)

    strip(rendered).should match strip <<-STR
      <h1 id="testing-&quot;o(n^2)&quot;">Testing &quot;O(n^2)&quot;</h1>
    STR
  end
end
