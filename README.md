## Overview

`pagehub-markdown` is a collection of extensions to the Markdown renderer used in [PageHub](www.pagehub.org).

Generally, the extensions automate stuff authors have to do manually and repetitively, such as generating table of contents, copying and highlighting snippets of code in some file, or reference other documents, etc. They are invoked directly in the Markdown using special directives, such as `[!toc!]` or `[!embed!]`.

## Installing

The gem is available in the Rubyforge repository, or can be installed directly (using Bundler) via the github repository. The dependencies are outlined in the `gemspec`, but here's a listing:

1. redcarpet
1. albino
1. json
1. nokogiri

## Usage

Let's say you've a bulk of Markdown text in a string and you want to render it, the interface is pretty similar to Redcarpet's:

```ruby
PageHub::Markdown.render! my_string
```

The `render!` method will invoke all the registered *processors*. `pagehub-markdown` also sports other processors known as *mutators* which have to be explicitly invoked (usually before rendering, but it doesn't really matter):

```ruby
PageHub::Markdown.mutate! my_string
```

### Processors, mutators, what?

Extensions, regardless of what they're called, will transform a directive found in the Markdown syntax into something else. However, sometimes the transformation needs to be done **only once** as opposed to **everytime the string is rendered**. So, the extensions were split into two "types":

1. **Processors** which are not supposed to transform the *original* or *raw* markdown content, but only the rendered (HTML, or whatever) version of it. Most extensions are processors. A good example of a processor would be the generator of a table of contents; in the persistent version of your Markdown content, you don't want it to contain the resulting HTML table, instead, you want it to be substituted everytime the page is rendered.
2. **Mutators** which are used to literally *substitute* something in the raw Markdown with something else, for example: if you want to inject the date of writing into an article, you don't want that date to be updated everytime the article is rendered, instead, only when it was *written* or *updated*, and as such a mutator should be used.

## Extensions

I'll try to keep this updated with the available extensions, but you can also check out the `lib/pagehub-markdown/` folder for the available processors and mutators.

The general invocation syntax is `[!!]` containing the extension keyword. For an extension with the keyword `myext`:

```markdown
[!myext!]
```

Arguments accepted by each extension are (usually) separated by whitespace and have to follow the extension keyword directly. For example, an extension that reserves the keyword `myext` and accepts a single string option:

```markdown
[!myext hello!]
```

### ToC Generator

This processor scans the Markdown for headings and constructs an HTML list with links to the heading sections. The extension accepts a single option, the threshold, which controls the "level" of the headings to be used in the ToC.

**Syntax**

```markdown
[!toc!]
```

Generating a ToC from only level 1 and 2 headings:

```markdown
[!toc 2!]
```

### Embedder

The embedder allows the author to embed external text or HTML pages into the current one. There are a few restrictions on what kind of content can be embedded, which are all customizable:

1. the mimetype (default: the content has to be either plain text, or HTML)
2. the size (default: 512 KBytes)
3. the host (you can filter out hosts, or whitelist the hosts from which content can be embedded)

There's a timeout that the Embedder will respect when fetching a resource. If it takes longer than the timeout, the resource will not be embedded and an appropriate error message will be set instead.

**Specifying the content**

Most of the time, it's not possible to embed an entire HTML page. The Embedder allows the definition of host processors that will handle the extraction of content from a certain host. For example, a GitHub Wiki processor can be defined that extracts the wiki page's content from the wiki HTML page and feeds it to the Embedder. Nokogiri is used for parsing the XML/HTML, but technically, any kind of content can be supported so long as you define a processor that does the extraction (which is obviously not required in the case of plain text documents.)

**Syntax**

```markdown
[!embed!](http://domain.com/path/to/resource)
```

Optional arguments:

1. the processor name

**Example: embedding a page from GitHub Wiki**

```markdown
[!embed github-wiki!](https://github.com/amireh/pagehub/wiki/PageHub-embedding-test)
```

We can also omit the `github-wiki` argument and leave it to the extension to figure it out (it can tell from the given URI).

** Example: embedding an HTML page from PageHub**

```markdown
[!embed pagehub!](http://pagehub.org/pagehub/embed-me)
```

Again, we could omit the `pagehub` argument since the extension can figure out the processor from the `pagehub.org` in the URI.

### Date Injector

This one is rather silly, but is also quite handy. It

## Legal stuff

`pagehub-markdown` the gem is licensed under the MIT terms like PageHub is.

```text
Copyright (c) 2012 Ahmad Amireh

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

