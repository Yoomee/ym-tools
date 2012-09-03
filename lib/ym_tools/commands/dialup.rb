module YmTools::Command
  class Dialup < Base
    def index
      mp3 = File.dirname(__FILE__) + '/../../support/dialup.mp3'
      system("/usr/bin/afplay #{mp3}")
    end
  end
end