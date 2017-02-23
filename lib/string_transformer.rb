class StringTransformer
  def initialize mode
    @mode = mode
  end

  def call words
    results = []
    words.each do |s|
      results << process(s)
    end
    results
  end

private
  def process word
    case @mode
      when :capitalize
        results << s.capitalize
      when :uppercase
        results << s.upcase
      when :lowercase
        results << s.downcase
      when :invert_case
        results << s.swapcase
      when :print
        puts s
    end
  end
end
