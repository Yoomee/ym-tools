require 'yoomee'
Rails::Generator::Commands::Create.send   :include,  Yoomee::Generator::Commands::Create
Rails::Generator::Commands::Destroy.send  :include,  Yoomee::Generator::Commands::Destroy
Rails::Generator::Commands::List.send     :include,  Yoomee::Generator::Commands::List
Rails::Generator::Commands::Update.send   :include,  Yoomee::Generator::Commands::Update