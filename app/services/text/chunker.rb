module Text
  class Chunker
    def self.call(text, size: 3500, overlap: 200)
      return [] if text.blank?
      chunks = []
      i = 0
      while i < text.length
        chunks << text[i, size]
        i += (size - overlap)
      end
      chunks
    end
  end
end
