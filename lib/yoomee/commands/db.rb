module Yoomee::Command
  class Db < Base
    def prepare
      display("Creating database......",false)
      display("complete.") if %x{rake db:create}
      display("Migrating database.....")
      %x{rake db:migrate}
      display("Seeding database.......",false)
      display("complete.") if %x{rake db:seed}
    end
  end
end