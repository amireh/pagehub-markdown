module PageHub
module Markdown

  describe "Processor: ToC Generator" do

    before do
      Markdown.configure()
    end

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
        <ol><li><a href="#toc_0">Food</a><ol><li><a href="#toc_1">Fruit</a></li><li><a href="#toc_2">Veggies</a><ol><li><a href="#toc_3">Lettuce</a></li></ol></li></ol></li><li><a href="#toc_4">Animals</a></li></ol>

        <h1 id="toc_0">Food</h1>

        <h2 id="toc_1">Fruit</h2>

        <h2 id="toc_2">Veggies</h2>

        <h3 id="toc_3">Lettuce</h3>

        <h1 id="toc_4">Animals</h1>
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


  end

end
end