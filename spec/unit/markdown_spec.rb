module PageHub

  describe Markdown do

    before { Markdown.configure }
    after  { Markdown.reset_config }

    it "should reject a non-callable processor" do
      expect { Markdown.add_processor(:pre_render, 5) }.to raise_error
    end

    it "should reject a processor assigned to an invalid stage" do
      expect { Markdown.add_processor(:invalid_stage, Proc.new {}) }.to raise_error
    end

    it "should reject a non-callable mutator" do
      expect { Markdown.add_mutator(5) }.to raise_error
    end

    it "should render plain Markdown" do
      rendered = Markdown.render! strip <<-EOF
        ## Hello World

        Moo.
      EOF

      rendered.should eq strip <<-EOF
        <h2 id="hello-world">Hello World</h2>

        <p>Moo.</p>
      EOF
    end

    it "should respect escape_scripts option" do
      Markdown.configure({ escape_scripts: false })

      rendered = Markdown.render! strip <<-EOF
        <script>foo</script>
      EOF

      rendered.should eq strip <<-EOF
        <script>foo</script>
      EOF
    end

    it "should escape JavaScript snippets" do
      rendered = Markdown.render! strip <<-EOF
        <script>foo</script>
      EOF

      rendered.should eq strip <<-EOF
        <p>&lt;script&gt;foo&lt;/script&gt;</p>
      EOF
    end

    it "should highlight syntax" do
      rendered = Markdown.render! strip <<-EOF
        ```javascript
        var foo = 5;
        ```
      EOF

      rendered.should eq full_strip <<-EOF
        <div class="highlight"><pre><span class="kd">var</span> <span class="nx">foo</span> <span class="o">=</span> <span class="mi">5</span><span class="p">;</span>
          </pre></div>
      EOF
    end

    it "should highlight syntax of an unknown language as plain text" do
      rendered = Markdown.render! strip <<-EOF
        ```foobar
        var foo = 5;
        ```
      EOF

      rendered.should eq full_strip <<-EOF
        <div class="highlight"><pre>var foo = 5;
        </pre></div>
      EOF
    end

  end

end