require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper
  
  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(File.read(index_url))

    student_array = []

    index_page.css("div.student-card").each do | student |
      student_array << {
      :name => student.css("h4.student-name").text,
      :location => student.css("p.student-location").text,
      :profile_url => student.css("a").attribute("href").value,
      }
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(File.read(profile_url))
    
    profile_hash = {        
        :profile_quote => profile_page.css("div.profile-quote").text,
        :bio => profile_page.css("div.bio-content div.description-holder p").text

      }

    social_array = profile_page.css("div.social-icon-container a").map(&:values).flatten

    social_array.each do | site |
      if site.include? "twitter"
        profile_hash[:twitter] = site
      elsif site.include? "github"
        profile_hash[:github] = site
      elsif site.include? "linkedin"
        profile_hash[:linkedin] = site
      else
        profile_hash[:blog] = site
      end
    end

    profile_hash
  end
end

