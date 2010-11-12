module Yoomee::Command
  class Bundle < Base
    
    def edit
      shell("mate #{escaped_bundle_path}/")
    end

    def install
      bundles_dir = bundle_path.chomp("/Yoomee.tmbundle")
      Dir.mkdir(bundles_dir) unless File.directory?(bundles_dir)
      if File.directory?(bundle_path)
        display("Bundle already installed, use ym bundle:update.")
      else
        git("clone", "textmate/yoomee", bundle_path)
        shell("osascript -e 'tell app \"TextMate\" to reload bundles'")
        display("Bundle installed successfully.")
      end
    end
    
    def reveal
      shell("open -a Finder #{escaped_bundle_path.chomp("/Yoomee.tmbundle")}")
    end
    
    def update
      if File.directory?(bundle_path)
        display("Moved existing version of bundle to trash.") if trash(bundle_path)
        install
      else
        display("Bundle not yet installed, installing now...")
        install
      end
    end
    
    private
    def bundle_path
      "#{ENV['HOME']}/Library/Application Support/TextMate/Bundles/Yoomee.tmbundle"
    end
    
    def escaped_bundle_path
      bundle_path.gsub(/ /,"\\ ")
    end

  end
end