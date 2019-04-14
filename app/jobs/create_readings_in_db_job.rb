class CreateReadingsInDbJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin
      reading = Reading.create!(args.extract_options!)
      Rails.cache.write("reading-#{reading.number}}" , nil) if reading.persisted?
    rescue => e
      logger.error "#{args.extract_options!}"
      logger.error e.message
      logger.error e.backtrace.join("\n")
    end
  end
end
