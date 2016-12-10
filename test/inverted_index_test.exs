defmodule InvertedIndexTest do
  use ExUnit.Case
  doctest InvertedIndex

  test "extracts terms from a string" do
    text = "Turtles love pizza"
    assert InvertedIndex.extract_terms(text) === ~w(Turtles love pizza)
  end

  test "lower_case_filter lower cases all terms" do
    terms = ~w(TurTleS LovE PiZzA)
    assert InvertedIndex.lower_case_filter(terms) === ~w(turtles love pizza)
  end

  test "dedup_filter removes duplicate terms" do
    terms = ~w(love pizza pizza turtles turtles turtles turtles)
    assert InvertedIndex.dedup_filter(terms) === ~w(love pizza turtles)
  end

  test "stop_words_filter removes stop words from terms" do
    terms = ~w(is I love my 999 if are turtles)
    stop_words = ~w(are is if)
    assert InvertedIndex.stop_words_filter(terms, stop_words) === ~w(I love my 999 turtles)
  end

  test "prefix_filter adds a tag to each term" do
    terms = ~w(turtles love pizza)
    assert InvertedIndex.prefix_filter(terms, "name") === ~w(name:turtles name:love name:pizza)
  end

  test "combine filters" do
    stop_words = ~w(are is if)

    text = "My pizza is is is are if pizza ------- good"
    terms = text
            |> InvertedIndex.extract_terms
            |> InvertedIndex.lower_case_filter
            |> InvertedIndex.dedup_filter
            |> InvertedIndex.stop_words_filter(stop_words)
            |> InvertedIndex.prefix_filter("tag")

    assert terms === ~w(tag:my tag:pizza tag:good)
  end

  test "convert document" do
    document = %{
      id: "123",
      body: "Turtles love pizza"
    }

    converter = fn(d) ->
      %{
        docId: d.id,
        text: d.body
      }
    end

    db = InvertedIndex.build(document, converter)
    assert db === %{docId: "123", text: "Turtles love pizza"}
  end

  test "invert" do
    converted_document = %{
      docId: "123",
      text: "Turtles if are the a love pizza"
    }
    terms = InvertedIndex.invert(converted_document)
    assert terms === ~w(docId:123 text:turtles text:love text:pizza)
  end

  test "full process" do
    document = %{
      id: "123",
      filename: "document123.txt",
      body: "Turtles if are the a love pizza"
    }

    converter = fn(d) ->
      %{
        docId: d.id,
        filename: d.filename,
        text: d.body
      }
    end

    terms = document
            |> InvertedIndex.build(converter)
            |> InvertedIndex.invert

    assert terms === ~w(docId:123 filename:document123.txt text:turtles text:love text:pizza)
  end


  # index: wikipedia
  # %{
  #   text:turtles => [document123.txt],
  #   text:love => [document123.txt],
  #   text:pizza => [document123.txt, document456.txt],
  #   ....
  # }



end
