defmodule TermFrequency do

  def words_from(document) do
    # List.flatten(Regex.scan(~r/[A-Za-z\d-]+/, document))
    # split(regex, string, options \\ [])
    # List.flatten(Regex.split(~r/[^\w]/, document))

    map_fn = fn x -> String.split(x, ~r/[^A-Za-z0-9_]/) end
    fliter_fn = fn x -> String.length(x) > 0 end

    document
      |> map_fn.()
      |> List.flatten
      |> Enum.filter(fliter_fn)
  end

  def term_frequency(word, words) do
    Enum.count(words, &(&1 === word))
  end

  def tf(word, document) do
    precision = 5
    words = words_from(document)
    Float.round(term_frequency(word, words) / Enum.count(words), precision)
  end

  def n_containing(word, documents) do
    Enum.reduce(documents, 0, fn(doc, acc) ->
        if String.match?(doc, ~r/#{word}/i) do
          acc + 1
        else
          acc + 0
        end
      end
    )
  end

  def idf(word, documents) do
    precision = 5
    number_of_documents = Enum.count(documents)
    documents_with_word = n_containing(word, documents)
    Float.round(:math.log(number_of_documents / (1 + documents_with_word)), precision)
  end

  def tfidf(word, document, documents) do
    precision = 5
    Float.round(tf(word, document) * idf(word, documents), precision)
  end
end

