# frozen_string_literal: true
namespace :db do
  desc 'Reset database, clean up all the data'
  task reset: [:set_rails_env] do
    on primary fetch(:seed_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:reset"
        end
      end
    end
  end

  desc 'Load seed data into database with db:seed_fu'
  task seed_fu: [:set_rails_env] do
    on primary fetch(:seed_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed_fu"
        end
      end
    end
  end

  desc 'Load seed data into database with db:seed_fu then reindex solr'
  task seed_fu_reindex: [:set_rails_env] do
    on primary fetch(:seed_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed_fu"
          execute :rake, "sunspot:solr:reindex"
        end
      end
    end
  end

  desc 'Load seed data into database with db:seed'
  task seed: [:set_rails_env] do
    on primary fetch(:seed_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed"
        end
      end
    end
  end

  task :set_rails_env do
    set :rails_env, (fetch(:rails_env) || fetch(:stage))
  end
end

namespace :load do
  task :defaults do
    set :seed_role, fetch(:seed_role, :db)
  end
end
