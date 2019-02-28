module Jekyll
  class BookTable < Page
    def initialize(site, base, dir, year = -1)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      @year = year

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'book_table.html')
      if year < 0
        self.data['title'] = 'All Reading'
      else
        self.data['title'] = "#{year} Reading"
      end
      self.data['year'] = @year
      self.data['years_list'] = BookTable.get_years_for_site(site)

      seed_books!(site)
      sort_books!
    end

    def self.get_years_for_site(site)
      return [2019, 2018, 2017, 2016, 2015]
    end

    def sort_books!
      self.data['books'].sort! { |a, b| a.data['alpha'] <=> b.data['alpha'] }
    end

    def seed_books!(site)
      self.data['books'] = []
      site.collections['books'].docs.each do |book|
        if @year < 0
          self.data['books'] << book
        else
          this_year = false
          book.data['notes'].each do |note|
            if note['date'].year == @year
              this_year = true
            end
          end

          self.data['books'] << book if this_year
        end
      end
    end
  end

  class BookTableGenerator < Generator
    safe true

    def generate(site)
      years = []

      site.collections['books'].docs.each do |book|
        year = book.data['notes'][0]['date'].year
        unless years.include? year
          years << year
        end
      end

      if site.layouts.key? 'book_table'
        dir = site.config['books_dir'] || 'reading'

        site.pages << BookTable.new(site, site.source, dir)

        years.each do |year|
          site.pages << BookTable.new(site, site.source, File.join(dir, year.to_s), year)
        end
      end
    end
  end
end