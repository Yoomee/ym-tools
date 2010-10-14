Rails::Generator::Commands::Create.class_eval do
  def insert(relative_destination, regexp, *args, &block)
    gsub_file(relative_destination, regexp, *args, &block)
    logger.insert "magic_create action added to #{relative_destination}"
  end
end

Rails::Generator::Commands::Destroy.class_eval do
  def insert(relative_destination, regexp, *args, &block)
    gsub_file(relative_destination, regexp, *args, &block)
    logger.insert "magic_create action added to #{relative_destination}"
  end
end

Rails::Generator::Commands::Update.class_eval do
  def insert(relative_destination, regexp, *args, &block)
    gsub_file(relative_destination, regexp, *args, &block)
    logger.insert "magic_create action added to #{relative_destination}"
  end
end

Rails::Generator::Commands::List.class_eval do
  def insert(relative_destination, regexp, *args, &block)
    gsub_file(relative_destination, regexp, *args, &block)
    logger.insert "magic_create action added to #{relative_destination}"
  end
end

def gsub_file(relative_destination, regexp, *args, &block)
  path = relative_destination
  content = File.read(path).gsub(regexp, *args, &block)
  File.open(path, 'wb') { |file| file.write(content) }
end