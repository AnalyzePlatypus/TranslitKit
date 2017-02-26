=begin
  TODO
    * Dependency inject the module classes, for easy stubbing when testing
=end
require "string_transformer"

module TranslitKit
  class StringPipeline

    attr_accessor :modules

    # Initializer:
    # Create a new StringPipeline
    # Takes an array of symbols, each corresponding
    # To a processing module
    def initialize modules
      @modules = modules

      @available_modules = {
        capitalize:  StringTransformer.new(:capitalize),
        uppercase:   StringTransformer.new(:uppercase),
        lowercase:   StringTransformer.new(:lowercase),
        invert_case: StringTransformer.new(:invert_case),
        print:       StringTransformer.new(:print),


=begin
        In development:

        find_transliterations:  TransliterationRecognizer.new

        remove_english:     EnglishRemover.new,
        remove_numbers:     Eliminator.new(:numbers),
        remove_punctuation: Eliminator.new(:punctuation),
        remove_duplicate_chars:  DuplicateRemover.new,

        generate_syn_file:  Synonymizer.new
        write_file:         FileWriter.new
=end
      }
    end

    def process array
      @array = array
      run()
    end

  private
    def run
      results  = []
      @modules.shift.call @array
      @modules.each do |m|
        puts m
        # v New results                 v Previous run
        results = @available_modules[m].call(results)
        puts results
      end
      results
    end

  end
end
=begin
# testing area
# Order commands in the initializer
# To customize behavior
# Command: $ ruby string_pipeline.rb

pipeline = StringPipeline.new(
            :capitalize,
            :print
          )
pipeline.process %w[bro i can't believe it works]
=end
