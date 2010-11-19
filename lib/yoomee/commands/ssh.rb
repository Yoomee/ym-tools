module Yoomee::Command
  class Ssh < Base
    def index
      system "ssh si@git.yoomee.com -p 316"
    end
  end
end