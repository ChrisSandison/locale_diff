module LocaleDiff
  class Runner

    class FiletypeError < StandardError
    end

    def self.run
      # start at the root folder and begin performing the diff operation on all inner locale directories

      Dir.glob("#{LocaleDiff.app_root}/#{LocaleDiff.locale_root}*").select{ |file| File.directory?(file)}.each do |directory|
        
        unless self.skip_directories.include?(directory)
          # Get a set of locale files and begin performing the diff operation on them
          locale_files = Dir.glob("#{directory}/*")
         
          # set up the file arguments to be passed into the diff engine
          diff_files = self.get_file_info(locale_files)
          LocaleDiff::Diff.new(diff_files).begin!
        end
      end

      # TODO Also perform this operation for any locale files directly inside of the locale directory
    end

    private

      def self.skip_directories
        [".", ".."] + LocaleDiff.skip_directories
      end

      def self.get_file_info(locale_files)
        # Then get the language it represents
        # Then get store it all in a hash
        accepted_formats = [".yml", ".rb"]

        diff_files = []
        locale_files.each do |file|
          # ensure a good filetype before we go reading this in
          unless accepted_formats.include?(File.extname(file))
            raise FiletypeError(file, "Locale file is not one of the accepted formats. Pleasure ensure you are using .rb or .yml to store your locales.")
          end

          # otherwise get all of the information
          diff_files << {
            lang: File.basename(file, File.extname(file)),
            type: File.extname(file),
            path: file
          }
        end
        diff_files
      end

  end
end