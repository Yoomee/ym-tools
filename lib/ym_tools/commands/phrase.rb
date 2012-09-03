module YmTools::Command
  class Phrase < Base
    def index
      phrases = File.readlines(File.dirname(__FILE__) + '/../../support/phrases.txt')
      phrase = phrases[rand(phrases.size)]
      puts phrase
      system("say -v Alex #{phrase.gsub(/'/, "\\\\'")}")
    end
  end
end