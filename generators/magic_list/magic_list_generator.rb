require File.expand_path(File.dirname(__FILE__) + "/../insert_commands.rb")

class MagicListGenerator < Rails::Generator::NamedBase
  def manifest
    if plural_name == singular_name
      logger.readme("Please supply a singular Model name, e.g. NewsFeedItem")
    else
      record do |m|
        root_path = @args.first || "."
        m.class_collisions "#{class_name}Controller", "#{class_name}ControllerTest", "#{class_name}Helper", "#{class_name}HelperTest"
        m.directory File.join("#{root_path}/app/controllers")
        m.template 'controller.rb', File.join("#{root_path}/app/controllers",class_path,"#{plural_name}_controller.rb")
        m.insert "#{root_path}/app/controllers/#{plural_name}_controller.rb", /^.*#{class_name.pluralize}Controller.*$/ do |match|"#{match}\n#{magic_actions}" end
        m.directory File.join("#{root_path}/app/views/", plural_name)
        m.template('_magic_list.html.haml', "#{root_path}/app/views/#{plural_name}/_#{plural_name}_list.html.haml")
        m.template('_magic_list_item.html.haml', "#{root_path}/app/views/#{plural_name}/_#{plural_name}_list_item.html.haml")
        m.template('_magic_form.html.haml', "#{root_path}/app/views/#{plural_name}/_#{plural_name}_form.html.haml")
        logger.readme("Example usage: =render(\"#{plural_name}/#{plural_name}_list\", :#{plural_name} => @#{plural_name}, :new_#{singular_name} => #{class_name}.new)")
      end
    end
  end
  
  def magic_actions
    <<-EOF
  def magic_create
    if request.xhr?
      render :update do |page|
        @#{singular_name} = #{class_name}.new(params[:#{singular_name}])
        if @#{singular_name}.save
          page["#{singular_name}_list"].append(render("#{plural_name}/#{plural_name}_item", :#{singular_name} => @#{singular_name}))
          @#{singular_name} = #{class_name}.new
        end
        page["#{singular_name}_form"].replace_html(render("#{plural_name}/#{plural_name}_form", :#{singular_name} => @#{singular_name}))
      end
    end
  end
  
  def destroy
    @#{singular_name} = #{class_name}.new(params[:id])
    render :update do |page|
      if @#{singular_name}.destroy
        page << "$('##{singular_name}_\#{@#{singular_name}.id}').fadeOut('fast', function() {$(this).remove();});"
      end
    end
  end
    EOF
  end
  
end