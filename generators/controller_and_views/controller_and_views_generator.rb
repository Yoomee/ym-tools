class ControllerAndViewsGenerator < Rails::Generator::NamedBase
  def manifest
    if plural_name == singular_name
      logger.readme("Please supply a singular Model name, e.g. NewsFeedItem")
    else
      record do |m|
        root_path = @args.first || "."
        m.class_collisions "#{class_name}Controller"
        m.directory File.join("#{root_path}/client/app/controllers")
        m.template 'controller.rb', File.join("#{root_path}/client/app/controllers",class_path,"#{plural_name}_controller.rb")
        m.directory File.join("#{root_path}/client/app/views/", plural_name)
        m.template('_form.html.haml', "#{root_path}/client/app/views/#{plural_name}/_form.html.haml")
        m.template('edit.html.haml', "#{root_path}/client/app/views/#{plural_name}/edit.html.haml")
        m.template('index.html.haml', "#{root_path}/client/app/views/#{plural_name}/index.html.haml")
        m.template('new.html.haml', "#{root_path}/client/app/views/#{plural_name}/new.html.haml")
        m.template('show.html.haml', "#{root_path}/client/app/views/#{plural_name}/show.html.haml")
      end
    end
  end
  
end