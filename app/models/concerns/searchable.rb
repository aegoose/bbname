module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    after_commit on: :create do
      SearchIndexerWorker.perform_async("index", self.class.name, self.id)
    end

    after_update do
      need_update = false
      if self.respond_to?(:indexed_changed?)
        need_update = indexed_changed?
      end

      SearchIndexerWorker.perform_async("index", self.class.name, self.id) if need_update
    end

    after_commit on: :destroy do
      SearchIndexerWorker.perform_async("delete", self.class.name, self.id)
    end
  end
end
