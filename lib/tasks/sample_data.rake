namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Quote.create!(quote_text: "Make mistakes of ambition, not mistakes of sloth.",
                         author: "Niccolo Machiavelli")
    Quote.create!(quote_text: "There is nothing noble in being superior to your fellow man; true nobility is being superior to your former self.",
                         author: "Ernest Hemingway")
    Quote.create!(quote_text: "Twenty years from now you will be more dissapointed by the things you didn't do by than the ones you did.",
                         author: "Mark Twain")

  end
end