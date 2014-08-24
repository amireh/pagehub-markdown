module PageHub
module Markdown
  describe "Mutator: Date Injector" do

    before { Markdown.configure }
    after  { Markdown.reset_config }
    
    it "should inject date" do
      Markdown.configure({ escape_scripts: true })

      raw = strip <<-EOF
        [!date!]
      EOF

      Markdown.mutate!(raw)
      rendered = Markdown.render! raw

      rendered.should eq strip <<-EOF
        <p>#{DateTime.now.strftime("%D")}</p>
      EOF
    end

    it "should accept custom date format" do
      Markdown.configure({ escape_scripts: true })

      raw = strip <<-EOF
        [!date %Y-%M!]
      EOF

      Markdown.mutate!(raw)
      rendered = Markdown.render! raw

      rendered.should eq strip <<-EOF
        <p>#{DateTime.now.strftime("%Y-%M")}</p>
      EOF
    end

  end

end
end