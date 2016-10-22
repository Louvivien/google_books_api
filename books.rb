require './google_books_api.rb'

#Register on https://console.developers.google.com to get a valid API Key 
GOOGLE_API = ''

ERRORS = {
  api_key_not_found: 'You must set your google api key',
  invalid_number_of_arguments: 'Usage: books <title of the book>'
}

def perform_search(text)
  abort(ERRORS[:api_key_not_found]) if GOOGLE_API.empty?

  puts "Books for '#{text}'"
  books = GoogleBooksApi.new(GOOGLE_API).search_books(text)

  if books.count.zero?
    puts "Nothing found"
  else
    #Remove duplicates based on title. (for example: Alice's Adventures in Wonderland (1920) and Alice's Adventures in Wonderland (1898))
    books.uniq!{|b| b['volumeInfo']['title']}

    books.map.with_index(1) do |book, i|
      puts "#{i}: #{book['volumeInfo'].fetch('authors', ['-unknown-']).join(', ')} - #{book['volumeInfo']['title']} (#{book['volumeInfo']['publishedDate']})"
    end
  end
end

def main()
  abort(ERRORS[:invalid_number_of_arguments]) if ARGV.count.zero?
  arguments = ARGV.join(' ')

  perform_search(arguments)
end

main()