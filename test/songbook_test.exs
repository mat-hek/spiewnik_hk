defmodule SongbookTest do
  use ExUnit.Case

  test "parse -> serialize is identity" do
    text = File.read!("songbook.txt")
    assert text |> Songbook.parse() |> Songbook.serialize() == text
  end

  test "to_pdf generates pdf" do
    Songbook.to_pdf("songbook.txt")
    assert {:ok, _stat} = File.stat("output/songbook.pdf")
  end
end
