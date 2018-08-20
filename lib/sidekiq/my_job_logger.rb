module Sidekiq

  class MyJobLogger
    def call(item, queue)
      #
      # Optionally add context to all log lines of a given job, in addition to
      # Sidekiq’s default “TID-xxx JID-yyy” context.
      #
      Sidekiq::Logging.with_context("source=#{item['class']}") do
        begin
          start = Time.now
          logger.info('start')
          yield
          logger.info("count#job.success=1 measure#job.duration=#{elapsed(start)}s")
        rescue Exception
          logger.info("count#job.failure=1 measure#job.duration=#{elapsed(start)}s")
          raise
        end
      end
    end

    private

    def elapsed(start)
      (Time.now - start).round(3)
    end

    def logger
      Sidekiq.logger
    end
  end
end
