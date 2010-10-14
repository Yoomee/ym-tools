require File.expand_path(File.dirname(__FILE__) + "/../insert_commands.rb")

class MagicListGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.class_collisions "#{class_name}Controller", "#{class_name}ControllerTest", "#{class_name}Helper", "#{class_name}HelperTest"
      m.directory File.join('client/app/controllers')
      m.insert "client/app/controllers/#{plural_name}_controller.rb", /^.*#{class_name.pluralize}Controller.*$/ do |match|"#{match}\n#{magic_create_action}" end
      m.directory File.join('client/app/views/', plural_name)
      m.template('_magic_list.html.haml', "client/app/views/#{plural_name}/_magic_list.html.haml")
      m.template('_magic_list_item.html.haml', "client/app/views/#{plural_name}/_magic_list_item.html.haml")
      m.template('_magic_form.html.haml', "client/app/views/#{plural_name}/_magic_form.html.haml")
      logger.readme("Example usage: =render(\"#{plural_name}/magic_list\", :#{plural_name} => @#{plural_name}, :new_#{singular_name} => #{class_name}.new)")
    end
  end
  
  def magic_create_action
    <<-EOF
  def magic_create
    if request.xhr?
      render :update do |page|
        if @#{singular_name}.save
          page["magic_#{singular_name}_list"].append(render("#{plural_name}/magic_list_item", :#{singular_name} => @#{singular_name}))
          @#{singular_name} = #{class_name}.new
        end
        page["magic_#{singular_name}_form"].replace_html(render("#{plural_name}/magic_form", :#{singular_name} => @#{singular_name}))
      end
    end
  end
    EOF
  end
end