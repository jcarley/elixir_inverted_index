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
    List.flatten(Regex.scan(~r/[A-Za-z\d]+/, s))
  end

  def lower_case_filter(terms) do
    Enum.map(terms, fn t -> String.downcase(t) end)
  end

  def dedup_filter(terms) do
    Enum.uniq terms
  end

  def stop_words_filter(terms, stop_words) do
    terms -- stop_words
  end

  def prefix_filter(terms, tag) do
    Enum.map(terms, fn t -> "#{tag}:#{t}" end)
  end

end
