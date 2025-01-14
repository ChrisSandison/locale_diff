module MissingText
  class Runner

    def self.run
      # create a Batch entry that the record can reference in order to group this session
      MissingText::Batch.create

      # start at the root folder and begin performing the diff operation on all inner locale directories

      Dir.glob("#{MissingText.app_root}/#{MissingText.locale_root}*").select{ |file| File.directory?(file)}.each do |directory|
        
        unless self.skip_directories.include?(File.basename(directory))

          # Get a set of locale files and begin performing the diff operation on them
          locale_files = self.get_locale_files(directory)
         
          # set up the file arguments to be passed into the diff engine
          if locale_files.present?
            diff_files = self.get_file_info(locale_files)

            MissingText::Diff.new(diff_files).begin!
          end
        end
      end

      # Also perform this operation for any locale files directly inside of the locale directory

      if MissingText.search_direct_locale

        direct_locale_files = self.skip_files(Dir.glob("#{MissingText.app_root}/#{MissingText.locale_root}*.yml") + 
          Dir.glob("#{MissingText.app_root}/#{MissingText.locale_root}*.rb"), "#{MissingText.app_root}/#{MissingText.locale_root}")

        if direct_locale_files.present?
          direct_locale_files = get_file_info(direct_locale_files)
          MissingText::Diff.new(direct_locale_files).begin!
        end

      end
    end

    private

      def self.skip_directories
        [".", ".."] + MissingText.skip_directories
      end

      def self.get_file_info(locale_files)
        # Then get the language it represents
        # Then get store it all in a hash
        accepted_formats = [".yml", ".rb"]

        diff_files = []
        locale_files.each do |file|
          # ensure a good filetype before we go reading this in
          if accepted_formats.include?(File.extname(file))
            # otherwise get all of the information
            diff_files << {
              lang: File.basename(file, File.extname(file)),
              type: File.extname(file),
              path: file
            }
          else
            MissingText::Warning.create(
              filename: file,
              warning_type: MissingText::Warning::FILE_TYPE_ERROR,
              missing_text_batch_id: MissingText::Batch.last.id
            )
          end

        end
        diff_files
      end

      # Gets all the locale files in a directory
      def self.get_locale_files(directory)
        locale_files = Dir.glob("#{directory}/*")
        locale_files = self.skip_files(locale_files, directory)
        locale_files
      end

      # Skips any files that match ANY of the regexes in the initializer
      def self.skip_files(files, directory)
        files = files.select{ |file| MissingText.skip_patterns.inject(true) { |result, pattern| result && (pattern !~ File.basename(file)) } }

        if files.blank?
          MissingText::Warning.create(
            filename: directory,
            warning_type: MissingText::Warning::STRICT_REGEX,
            missing_text_batch_id: MissingText::Batch.last.id
          )
        end
        return files
      end

  end
end