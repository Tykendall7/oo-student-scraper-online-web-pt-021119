require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_profile_link = "#{student.attr('href')}"
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
  	doc = Nokogiri::HTML(html)

 	    students_twitter = []
    students_linkedin = []
    students_github = []
    students_youtube = []
    students_blog = []

     doc.xpath('//div[@class="social-icon-container"]/a').map do |link|
      if link['href'].include?("twitter")
        students_twitter << link['href']
      end
    end


     doc.xpath('//div[@class="social-icon-container"]/a').map do |link|
      if link['href'].include?("linkedin")
        students_linkedin << link['href']
      end
    end

     doc.xpath('//div[@class="social-icon-container"]/a').map do |link|
      if link['href'].include?("github")
        students_github << link['href']
      end
    end

     doc.xpath('//div[@class="social-icon-container"]/a').map do |link|
      if !(link['href'].include?("github")) &&
         !(link['href'].include?("linkedin")) &&
         !(link['href'].include?("twitter"))
         students_blog = link['href']
      end
    end

     students_quote = doc.css(".profile-quote").text
    students_bio = doc.css(".description-holder p").text

     students_twitter
    students_linkedin
    students_github
    students_youtube
      if students_youtube = ""
        students_youtube = nil
      end
    students_blog

     out_put = {:twitter=>students_twitter[0],
               :linkedin=>students_linkedin[0],
               :github=>students_github[0],
               :profile_quote=>students_quote,
               :blog=>students_blog,
               :bio=> students_bio}
    out_put.delete_if {|key, value| value == [] || value == nil}

     out_put
  end
end
