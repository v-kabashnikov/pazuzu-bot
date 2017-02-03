class Vocabulary < ApplicationRecord
  belongs_to :character

  def update_content(word)
    content = word if self.content.nil?
    content = self.content + " " + word if self.content.present?
    self.update_column(:content, content)
  end
end
