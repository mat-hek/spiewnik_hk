defmodule Songbook do
  def to_pdf(path_to_songbook) do
    songbook =
      File.read!(path_to_songbook)
      |> parse()
      |> Enum.map(fn
        %{type: :category, name: category} ->
          """
          <h1 class="category">
            #{String.trim(category)}
          </h1>
          """

        %{type: :song, title: title, text: text, author: author, capo: capo} ->
          author = Enum.map(author, &"<b>#{&1}</b><br>")
          capo = if capo, do: "<br><i>Capo #{capo}</i><br>"
          text = Regex.replace(~r/\[(.*)\]/U, text, ~s(<span style="color:red">\\1</span>  ))

          """
          <h3>#{String.trim(title)}</h3>
          #{author}
          #{capo}
          <pre style="font-family: courier;page-break-after: always;">
          #{String.trim(text)}
          </pre>
          """
      end)

    songbook = """
    <html style="font-family:arial">
    <style>
    .category {
      page-break-after: always;page-break-inside: avoid; padding-top: 18cm; text-align:center; display: block
    }
    </style>
    #{songbook}
    </html>
    """

    File.mkdir_p!("output")
    File.write!("output/songbook.html", songbook)

    :os.cmd(
      'wkhtmltopdf --encoding utf8 --dump-outline output/outline.xml output/songbook.html output/songbook.pdf'
    )

    :ok
  end

  def parse(source) do
    Regex.split(~r/^#(song|category) /m, source, include_captures: true, trim: true)
    |> Enum.chunk_every(2)
    |> Enum.map(fn
      ["#category ", category] ->
        %{type: :category, name: category}

      ["#song ", song] ->
        [title, text] = String.split(song, "\n", parts: 2)
        {text, metadata} = parse_song_metadata(text, %{author: [], capo: nil})
        %{type: :song, title: title, text: text} |> Map.merge(metadata)
    end)
  end

  defp parse_song_metadata("#author " <> rest, metadata) do
    [author, rest] = String.split(rest, "\n", parts: 2)
    metadata = Map.update!(metadata, :author, &(&1 ++ [author]))
    parse_song_metadata(rest, metadata)
  end

  defp parse_song_metadata("#capo " <> rest, metadata) do
    [capo, rest] = String.split(rest, "\n", parts: 2)
    parse_song_metadata(rest, %{metadata | capo: capo})
  end

  defp parse_song_metadata(text, metadata) do
    {text, metadata}
  end

  def serialize(songbook) do
    Enum.map_join(songbook, fn
      %{type: :category, name: category} ->
        "#category #{category}"

      %{type: :song, title: title, text: text, author: author, capo: capo} ->
        author = Enum.map(author, &"#author #{&1}\n")
        capo = if capo, do: "#capo #{capo}\n"
        "#song #{title}\n#{author}#{capo}#{text}"
    end)
  end
end
