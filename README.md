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

## Usage

Because arcdown (.ad) files are parsed entirely with robust regular expressions,
formatting must match the above example exactly.

However not all of the above elements have to be included in an arcdown file.
In fact it's perfectly acceptable to parse an empty file. Arcdown will just
return an empty `%Arcdown.Article{}` struct.

There are some situations in which extraneous whitespace `\s` and newline `\n`
characters will be trimmed and ignored, but for the mostpart Arcdown wants you
to follow its format as close to the letter as possible in order to not have to
bloat its parsing logic with attempts to discern formatting errors.

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

## Availability

This library is currently published at for use with the public hex.pm
repository at https://hex.pm/packages/arcdown.

Source code is available at the [FunctionHaus Github Organization](
https://github.com/functionhaus) at
https://github.com/functionhaus/arcdown.


## License

Arcdown source code is released under Apache 2 License.
Check LICENSE file for more information.
