# Arcdown

[![CircleCI](https://circleci.com/gh/functionhaus/arcdown.svg?style=svg)](https://circleci.com/gh/functionhaus/arcdown)

Arcdown is a parsing library for articles written in Arcdown (.ad) format.

It is written in pure Elixir/Erlang with no additional dependencies when being
used in production.

# What is Arcdown (.ad) format?

Arcdown (.ad) format is a lightweight file format for writing full-featured
content and articles as plain text in order to easily parse them as rich
objects.

The objective of this format is to allow the author to write full articles
in plain text in order to easily parse them into rich objects in whatever
language you're using.

Arcdown supports the following features:

* title
* url slug
* author name and email
* topics and sub-topics
* tags
* article summary
* article content

Here is an example article written in *Arcdown (.ad)* format:

```
The Day the Earth Stood Still <the-day-the-earth-stood-still>
by Julian Blaustein <julian@blaustein.com>

Filed under: Films > Sci-Fi > Classic

Created @ 10:24pm on 1/20/2019
Published @ 10:20pm on 1/20/2019

* Sci-Fi
* Horror
* Thrillers
* Aliens

Summary:
A sci-fi classic about a flying saucer landing in Washington, D.C.

---

The Day the Earth Stood Still (a.k.a. Farewell to the Master and Journey to the
World) is a 1951 American black-and-white science fiction film from 20th Century
Fox, produced by Julian Blaustein and directed by Robert Wise.
```

Arcdown doesn't presume that you want to parse the Article content/body in any
particular way in order to give you as much flexibility as possible in its
usage. It's simple enough, however, to simply write the Article content as
Markdown (.md) and parse that later with a library like
[Earmark](https://github.com/pragdave/earmark).

It's suggested that Arcdown files with the content body written in Markdown use
the *.md.ad* file extension to remain conventionally consistent.

Additional content parsing options may be included in the future, but for now
the goal is to remain as content-agnostic as possible in order to give users the
choice of how format and write their own articles.

## Installation

The package can be installed by adding `arcdown` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:arcdown, "~> 0.1"}
  ]
end
```

Arcdown has no dependencies other than ex_doc which is only included in the `docs`
context.

## Usage

Parsing Arcdown text is easy thanks to a couple of helpers in the top-level
Arcdown module. The default interface permits parsing Arcdown text either
directly from a string, like this:

```elixir
{:ok, parsed} = Arcdown.parse_file "earth_stood_still.ad"
```

Or just by parsing the entire text from a string, like this:

```elixir
article_text = """
The Day the Earth Stood Still <the-day-the-earth-stood-still>
by Julian Blaustein <julian@blaustein.com>

Filed under: Films > Sci-Fi > Classic

Created @ 10:24pm on 1/20/2019
Published @ 4:30am on 4/2/2019

* Sci-Fi
* Horror
* Thrillers
* Aliens

Summary:
A sci-fi classic about a flying saucer landing in Washington, D.C.

---

The Day the Earth Stood Still (a.k.a. Farewell to the Master and Journey to the
World) is a 1951 American black-and-white science fiction film from 20th Century
Fox, produced by Julian Blaustein and directed by Robert Wise.
"""

{:ok, parsed} = Arcdown.parse full_article
```

In both instances, the parser will return a tuple in the format of
`{:ok, `%Arcdown.Article{}`}. The Article struct will contain all of its data
attributes fully parsed and formatted. Presuming that the text in both examples
above match the string-parsing example, the resulting struct would look like
this:

```elixir
%Arcdown.Article{
  author: "Julian Blaustein",
  content: "The Day the Earth Stood Still (a.k.a. Farewell to the Master and Journey to the\nWorld) is a 1951 American black-and-white science fiction film from 20th Century\nFox, produced by Julian Blaustein and directed by Robert Wise.\n",
  created_at: #DateTime<2019-01-20 22:24:00Z>,
  email: "julian@blaustein.com",
  published_at: #DateTime<2019-04-02 04:30:00Z>,
  slug: "the-day-the-earth-stood-still",
  summary: "A sci-fi classic about a flying saucer landing in Washington, D.C.",
  tags: [:sci_fi, :horror, :thrillers, :aliens],
  title: "The Day the Earth Stood Still",
  topics: ["Films", "Sci-Fi", "Classic"]
}
```

### Arcdown Formatting

Because arcdown (.ad) files are parsed entirely with robust regular expressions,
formatting must match the above example exactly.

However not all of the above elements have to be included in an arcdown file.
In fact it's perfectly acceptable to parse an empty file. Arcdown will just
return an empty `%Arcdown.Article{}` struct.

There are some situations in which extraneous whitespace `\s` and newline `\n`
characters will be trimmed and ignored, but for the mostpart Arcdown wants you
to follow its format as close to the letter as possible in order to not have to
bloat its parsing logic with attempts to discern formatting errors.

### The Arcdown Header

You're welcome to just parse header information, for example, if you haven't
written your article yet but know how you want to title and categorize it.
Here is an example of a complete header:

```
The Day the Earth Stood Still <the-day-the-earth-stood-still>
by Julian Blaustein <julian@blaustein.com>

Filed under: Films > Sci-Fi > Classic

Created @ 10:24pm on 1/20/2019
Published @ 10:20pm on 1/20/2019

* Sci-Fi
* Horror
* Thrillers
* Aliens

Summary:
A sci-fi classic about a flying saucer landing in Washington, D.C.
```

Notice how there is no three-hyphen *content divider* ending the header text
here. The divider has semantic importance in parsing Arcdown files, and always
denotes the beginning of a content section.

If your article contains no content yet, exclude the trailing divider.

### Arcdown Content

The *Content* portion of an Arcdown file always begins with the hyphen divider
`---` followed by two newline characters.

This is a valid Arcdown file in which the parser will simply extract the content
body and ignore any header parsing in the absence of header data:

```
---

The Day the Earth Stood Still (a.k.a. Farewell to the Master and Journey to the
World) is a 1951 American black-and-white science fiction film from 20th Century
Fox, produced by Julian Blaustein and directed by Robert Wise.
```

Omitting the hyphen divider `---` element will suggest to the parser that this
is actually the title of the article rather than the content. As such, the
divider must begin the parsed string, followed by two newlines, like this:
`---\n\nContent goes here.`

## Availability

This library is currently published at for use with the public hex.pm
repository at https://hex.pm/packages/arcdown.

Source code is available at the [FunctionHaus Github Organization](
https://github.com/functionhaus) at
https://github.com/functionhaus/arcdown.


## License

Arcdown source code is released under Apache 2 License.
Check LICENSE file for more information.
