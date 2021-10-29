class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.page_number(per_page, page)
    page = 1 if page <= 0
    limit(per_page).offset(per_page * (page - 1))
  end
end
