class StringHelper

  def self.to_title(s)
    small_words = %w{a an and the or for of nor}
    title_words = []
    s.split('_').each_with_index do |word, i|
      word.capitalize! unless small_words.include?(word)
      word.capitalize! if i == 0
      title_words.push(word)
    end
    title_words.join(' ')
  end

end
