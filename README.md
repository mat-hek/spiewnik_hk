# SpiewnikHk

## Installation

Install elixir and whktmltopdf and clone this repo.

## Usage

```
$ mix deps.get
$ iex -S mix
iex> Songbook.to_pdf("path/to/songbook.txt")
```

The songbook PDF will be stored in `output` directory.

To alter the text format of the songbook, use `Songbook.parse/1` and `Songbook.serialize/1`.
