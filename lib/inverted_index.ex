defmodule InvertedIndex do

  def build(document, converter) do
    converter.(document)
  end

  def invert(document) do
    keys = Map.keys(document)
    terms = Enum.map keys, fn(key) ->
      document[key]
        |> extract_terms
        |> lower_case_filter
        |> dedup_filter
        |> stop_words_filter(StopWords.stop_words)
        |> prefix_filter(key)
    end

    List.flatten(terms)
  end

  def extract_terms(s) do
    Regex.scan(~r(\b[A-Za-z0-9-_.]+\b), s)
    |> List.flatten()
  end

  def lower_case_filter(terms) do
    terms
    |> Enum.map(&String.downcase/1)
  end

  def dedup_filter(terms) do
    terms
    |> Enum.uniq
  end

  def stop_words_filter(terms, stop_words) do
    terms -- stop_words
  end

  def prefix_filter(terms, tag) do
    terms
    |> Enum.map(&("#{tag}:#{&1}"))
  end

end
