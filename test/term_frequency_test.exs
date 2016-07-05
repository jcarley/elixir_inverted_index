defmodule TermFrequencyTest do
  use ExUnit.Case
  doctest TermFrequency

  def document() do
    "Two roads diverged in a yellow wood,
    And sorry I could not travel both
    And be one traveler, long I stood
    And looked down one as far as I could
    To where it bent in the undergrowth;
    Then took the other, as just as fair,
    And having perhaps the better claim,
    Because it was grassy and wanted wear;
    Though as for that the passing there
    Had worn them really about the same,
    And both that morning equally lay
    In leaves no step had trodden black.
    Oh, I kept the first for another day!
    Yet knowing how way leads on to way,
    I doubted if I should ever come back.
    I shall be telling this with a sigh
    Somewhere ages and ages hence:
    Two roads diverged in a wood, and I-
    I took the one less traveled by,
    And that has made all the difference."
  end

  test "term_frequency returns frequency of appearance" do
    word = "roads"
    words = TermFrequency.words_from(document)
    term_frequency = TermFrequency.term_frequency(word, words)
    assert 2 === term_frequency
  end

  test "tf" do
    word = "roads"
    tf = TermFrequency.tf(word, document)
    assert 0.01389 === tf
  end

  test "n_containing counts the docs containing a word" do
    document1 = "Turtles love pizza"
    document2 = "Pizza originated in Italy"
    document3 = "You can order pizza as take out or have it delivered"
    document4 = "Hamburgers are the best on the grill"

    documents = [document1, document2, document3, document4]

    word = "pizza"
    document_count = TermFrequency.n_containing(word, documents)
    assert 3 === document_count
  end

  test "idf" do
    document1 = "The dog jumped over the cat"
    document2 = "Look over there, by the river"
    document3 = "Why is the tractor green"

    documents = [document1, document2, document3]

    word = "the"
    idf = TermFrequency.idf(word, documents)
    assert -0.28768 === idf
  end

  test "tfidf" do
    document1 = "The dog jumped over the cat"
    document2 = "Look over there, by the river"
    document3 = "Why is the tractor green"

    documents = [document1, document2, document3]

    word = "the"
    tfidf = TermFrequency.tfidf(word, document1, documents)
    assert tfidf === -0.04795
  end

  test "verify" do
    document1 = "Python is a 2000 made-for-TV horror movie directed by Richard
    Clabaugh. The film features several cult favorite actors, including William
    Zabka of The Karate Kid fame, Wil Wheaton, Casper Van Dien, Jenny McCarthy,
    Keith Coogan, Robert Englund (best known for his role as Freddy Krueger in the
    A Nightmare on Elm Street series of films), Dana Barron, David Bowe, and Sean
    Whalen. The film concerns a genetically engineered snake, a python, that
    escapes and unleashes itself on a small town. It includes the classic final
    girl scenario evident in films like Friday the 13th. It was filmed in Los Angeles,
    California and Malibu, California. Python was followed by two sequels: Python
    II (2002) and Boa vs. Python (2004), both also made-for-TV films."

    document2 = "Python, from the Greek word (πύθων/πύθωνας), is a genus of
    nonvenomous pythons[2] found in Africa and Asia. Currently, 7 species are
    recognised.[2] A member of this genus, P. reticulatus, is among the longest
    snakes known."

    document3 = "The Colt Python is a .357 Magnum caliber revolver formerly
    manufactured by Colt's Manufacturing Company of Hartford, Connecticut.
    It is sometimes referred to as a \"Combat Magnum\".[1] It was first introduced
    in 1955, the same year as Smith &amp; Wesson's M29 .44 Magnum. The now discontinued
    Colt Python targeted the premium revolver market segment. Some firearm
    collectors and writers such as Jeff Cooper, Ian V. Hogg, Chuck Hawks, Leroy
    Thompson, Renee Smeets and Martin Dougherty have described the Python as the
    finest production revolver ever made."

    documents = [document1, document2, document3]

    scores = Enum.map(TermFrequency.words_from(document1), &({&1, TermFrequency.tfidf(&1, document1, documents)}))
    sorted_scores = Enum.sort(scores, fn({_, s1}, {_, s2}) -> s1 > s2 end )
    IO.inspect(sorted_scores)
  end

end

