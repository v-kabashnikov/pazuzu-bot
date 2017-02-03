class Character < ApplicationRecord
  has_many :vocabularies

  def note_word(word)
    url = URI.parse("http://apilayer.net/api/detect?access_key="+ENV['languagelayer_api_key']+"&query="+ word)
    res = JSON.parse(Net::HTTP.get(url))
    if res["success"]
      if res["results"].first["language_code"] == "en"
        voc = self.vocabularies.find_or_create_by(title: "en")
      else
        voc = self.vocabularies.find_or_create_by(title: "ru")
      end
      voc.update_content(word)
    else
      res["error"]["info"]
    end
  end

end
