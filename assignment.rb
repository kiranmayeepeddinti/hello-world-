class LineAnalyzer
  attr_reader :highest_wf_count, :highest_wf_words, :content, :line_number

  def initialize (content, line_number)
    @content = content
    @line_number = line_number
    calculate_word_frequency()
 end

  def calculate_word_frequency()
    @highest_wf_words = []
    all_words = Hash.new(0)
    @highest_wf_count = 0
    @content.split.each do |word|
      all_words[word.downcase] += 1
    end
    @highest_wf_count = all_words.values.max
    all_words.each {|word, freq|
      @highest_wf_words << word if freq == @highest_wf_count
    }
  end
end

class Solution
  attr_reader :analyzers, :highest_count_across_lines, :highest_count_words_across_lines

  def analyze_file
    begin
      line_number = 0
      File.foreach("test.txt").with_index do |line, index|
        @analyzers << LineAnalyzer.new(line.chomp, index)
    end
    rescue Exception => e
      puts e.message
      puts "You need to create file test.txt first"
    end
  end

  def calculate_line_with_highest_frequency
    line_highest = 0
    @highest_count_across_lines = 0
    @highest_count_words_across_lines = []
    @analyzers.each {|analyzer|
      if @highest_count_across_lines < analyzer.highest_wf_count 
        @highest_count_across_lines = analyzer.highest_wf_count 
        line_highest = analyzer.line_number
      end
    }
    @analyzers.each {|analyzer|
      if !(analyzer.highest_wf_words.empty?) && !(analyzer.highest_wf_count < @highest_count_across_lines)
        @highest_count_words_across_lines << analyzer
      end
    }
  end

  def print_highest_word_frequency_across_lines
    @highest_count_words_across_lines.each_with_index {|words, index|
      unless words.nil?
        puts "#{words} (appears in line #{index})"
      end
    }
  end

  private
    def initialize
      @analyzers = []
    end
end
