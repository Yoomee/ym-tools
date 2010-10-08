class MagicListGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions "#{class_name}Controller", "#{class_name}ControllerTest", "#{class_name}Helper", "#{class_name}HelperTest"
      
      
      # line = "^(.*<%=class_name%>sController.*$)"
      # gsub_file "client/app/controllers/#{plural_name}_controller.rb", /(#{Regexp.escape(line)})/m do |match|
      #   "#{match}\n  #{render :file => 'templates/magic_create_action.rb'}"
      # end
      
      m.do_stuff
      
      m.directory File.join('client/app/controllers')
      m.template 'controller.rb', File.join('client/app/controllers',"#{file_name}_controller.rb")
      
      m.directory File.join('client/app/views/', plural_name)
      m.template('_magic_list.html.haml', "client/app/views/#{plural_name}/_magic_list.html.haml")
      m.template('_magic_list_item.html.haml', "client/app/views/#{plural_name}/_magic_list_item.html.haml")
      m.template('_magic_form.html.haml', "client/app/views/#{plural_name}/_magic_form.html.haml")
      

      
      logger.readme("Example usage: =render(\"#{plural_name}/magic_list\", :#{plural_name} => @#{plural_name}, :new_#{singular_name} => #{class_name}.new)")
    end
  end
  
  protected
  def gsub_file(relative_destination, regexp, *args, &block)
    path = destination_path(relative_destination)
    content = File.read(path).gsub(regexp, *args, &block)
    File.open(path, 'wb') { |file| file.write(content) }
  end
end