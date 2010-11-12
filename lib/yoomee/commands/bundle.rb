module Yoomee::Command
  class Bundle < Base

    def install
      bundles_dir = "#{ENV['HOME']}/Library/Application Support/TextMate/Bundles"
      Dir.mkdir(bundles_dir) unless File.directory?(bundles_dir)
      if File.directory?(File.join(bundles_dir, "Yoomee.tmbundle"))
        display("Bundle already installed, use ym bundle:update.")
      else
        git("clone", "textmate/yoomee", File.join(bundles_dir, "Yoomee.tmbundle"))
        shell("osascript -e 'tell app \"TextMate\" to reload bundles'")
        display("Bundle installed successfully.")
      end
    end
    
    def update
      bundle_path = "#{ENV['HOME']}/Library/Application Support/TextMate/Bundles/Yoomee.tmbundle"
      puts bundle_path
      if File.directory?(bundle_path)
        display("Moved existing version of bundle to trash.") if trash(bundle_path)
        install
      else
        display("Bundle not yet installed, installing now...")
        install
      end
    end

  end
end