require 'rubygems'
require 'csv' 
require 'mechanize'

Job = Struct.new(:title, :link_to_posting)

class Scraper
  def initialize(search_term)
  @job_array = []      
  agent = Mechanize.new

  page = agent.get("https://www.indeed.ca") 
  
  results = page.form_with(:name => 'jobsearch') do |search|
    search.q = search_term
  end

  page = results.submit

  page.links_with(:href => /\/rc\/clk.{43}/).each do |link|
    current_job = Job.new
    
    current_job.link_to_posting = link.uri

    current_job.title = link.text.strip

    @job_array << current_job
  end
  
  end

  def run
    return @job_array
  end
  
end

scrape = Scraper.new("engineering")
array = scrape.run
CSV.open('spreadsheet.csv', 'a') do |csv|
  csv << [array]
end