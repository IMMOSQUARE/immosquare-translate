namespace :immosquare_translate do
  ##============================================================##
  ## Function to translate translation files in rails app
  ## rake immosquare_translate:translate SOURCE_LOCALE=fr
  ##============================================================##
  desc "Translate translation files in rails app"
  task :translate_rails_locales => :environment do
    begin
      source_locale      = ENV.fetch("SOURCE_LOCALE", nil)      || "fr"
      reset_translations = ENV.fetch("RESET_TRANSLATIONS", nil) || false
      reset_translations = reset_translations == "true"

      raise("Please provide a valid locale")                         if !I18n.available_locales.map(&:to_s).include?(source_locale)
      raise("Please provide a valid boolean for reset_translations") if ![true, false].include?(reset_translations)

      locales = I18n.available_locales.map(&:to_s).reject {|l| l == source_locale }
      puts("Translating from #{source_locale} to #{locales.join(", ")} with reset_translations=#{reset_translations}")
      Dir.glob("#{Rails.root}/config/locales/**/*#{source_locale}.yml").each do |file|
        locales.each do |locale|
          ImmosquareTranslate::YmlTranslator.translate(file, locale, :reset_translations => reset_translations)
        end
      end
    rescue StandardError => e
      puts(e.message)
    end
  end
end
