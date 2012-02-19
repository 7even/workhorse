require 'gmail'
require 'octokit'
require 'open-uri'
require 'nokogiri'

module Workhorse
  class << self
    # конфиг, считываемый из config.yml и кэшируемый в @config
    def config
      file_path = File.expand_path('../../config.yml', __FILE__)
      @config ||= YAML.load_file(file_path)
    end
    
    # получение писем из ящика на GMail
    def gmail(mailbox = nil, password = nil)
      # если адрес и пароль не переданы, они берутся из конфига
      mailbox   ||= config['gmail']['mailbox']
      password  ||= config['gmail']['password']
      
      begin
        gmail = Gmail.connect(mailbox, password)
        
        if gmail.logged_in?
          gmail.inbox.emails(:unread).map do |email|
            from = email.from.first
            {
              sender:   "#{from.mailbox}@#{from.host}",
              date:     Time.parse(email.date),
              subject:  Mail::Encodings.value_decode(email.subject)
            }
          end
        else
          raise ArgumentError, 'Email and/or password were incorrect.'
        end
      ensure
        gmail.logout
      end
    end
    
    # получение 5 последних коммитов в определенный репозиторий на Github
    def github(repo = nil)
      # если название репозитория не передано, оно берется из конфига
      repo ||= config['github']['repo']
      
      Octokit.commits(repo).first(5).map do |commit|
        # fuck yeah
        commit    = commit.commit
        committer = commit.committer
        
        {
          committer:  committer.name,
          date:       Time.parse(committer.date),
          message:    commit.message.split("\n").first # нам достаточно заголовка коммита
        }
      end
    end
    
    # получение заголовков 5 последних новостей с lenta.ru
    def lenta_ru
      page = open('http://lenta.ru/rss/')
      doc  = Nokogiri::XML(page)
      
      doc.xpath('//channel/item').first(5).map do |item|
        {
          title:  item.xpath('.//title').first.content,
          date:   Time.parse(item.xpath('.//pubDate').first.content)
        }
      end
    end
  end
end
