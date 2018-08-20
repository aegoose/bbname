module PingyinParseable
  extend ActiveSupport::Concern

  included do
    # include ChinesePinyin::ClassMethods
  end

  def simple_letter_pinyin(cn_word)
    Pinyin.t(cn_word) { |letters| letters[0].downcase }
  end

  def word_to_pingyin(cn_word)
    # Pinyin.t(cn_word).gsub(/\s+/, '').downcase
    Pinyin.t(cn_word).downcase
  end

end
