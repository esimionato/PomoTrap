require "rubygems"
require "httparty"
require "ruby-debug"
require 'json'
require 'rufus/scheduler'

module Pomotrap

  class Client
    include HTTParty
    base_uri "http://localhost:3000"
    format :json

    attr_reader :api_token

    ICON = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'img', 'tomato.jpeg'))

    def initialize(token, debug=false)
      @api_token = token
      self.class.debug_output if debug
    end


    def activities
      todays_sheet = find_or_create_to_do_today
    end

    def display_stubbed
      result = JSON.parse("{\"tasks\": [ { \"id\":\"123456\", \"priority\":\"1\", \"description\":\"Task one.\", \"pomodoros\":\"0\", \"interruptions\":\"0\" }, { \"id\":\"123456\", \"priority\":\"2\", \"description\":\"Task two.\", \"pomodoros\":\"0\", \"interruptions\":\"0\" }] }")
    end


    def find_or_create_to_do_today
      today = date("today")
      get "to_do_today/#{today}", {:params => {}}
    end

    def create_activity(description)
      today = date("today")
      to_do_today = get "to_do_today/#{today}", {:params => {}}
      params = {:activity => {:description => description, :to_do_today_id => to_do_today["to_do_today"]["id"]}}
      post "to_do_todays/#{today}/activities", params
    end

    def fire_pomodoro(params={})
      priority = params.to_i
      @to_do_today = get "to_do_today/#{date("today")}", {:params => {}}
      activities_request = get "to_do_todays/#{date("today")}/activities", {:params => {:priority => priority}}
      activities = activities_request.parsed_response

      activity = activities.detect { |a| a["activity"]["priority"] == priority }
      post "to_do_todays/#{date('today')}/activities/#{activity['activity']['id'] }/pomodoros", { :pomodoro => params } # TODO fixme
      notify_about("pomodoro started!")

      # update priorities





      # scheduler = Rufus::Scheduler.start_new

      Rufus::Scheduler.start_new.every('5s') { notify_about("pomodoro running!") }

      # scheduler = Rufus::Scheduler::PlainScheduler.start_new(:thread_name => 'my scheduler')
      # 
      # scheduler.every '10s' do
      #   notify_about("pomodoro running!")
      # end
      # 
      # scheduler.start



      # post 'to_do_todays', {:to_do_today => params} # TODO fixme
    end


    def notify_about(message)
      title = 'Pomotrap'
      case RUBY_PLATFORM
      when /linux/
        system "notify-send '#{title}' '#{message}' "
      when /darwin/
        system "growlnotify -t '#{title}' -m '#{message}' --image #{Pomotrap::Solitaire::Pomodoro::ICON}"
      when /mswin|mingw|win32/
        # Snarl.show_message title, message, nil
      end
    end


    private


    def get(resource_name, data={})
      self.class.get("/#{resource_name}.json", :basic_auth => basic_auth, :query => data)
    end

    def post(resource_name, data)
      # self.class.post("/#{resource_name}.json", :basic_auth => basic_auth, :body => data)
      self.class.post("/#{resource_name}.json", :body => data)
    end

    def delete(resource_name, id)
      self.class.delete("/#{resource_name}/#{id}.json", :basic_auth => basic_auth)
    end

    def basic_auth
      {:username => self.api_token, :password => "api_token"}
    end

    # TODO DRY it up later
    def date(value)
      if value
        case value
        when "today"
          Date.today
        when "yesterday"
          Date.today - 1
        when "tomorrow"
          Date.today + 1
        else
          DateTime.parse(value)
        end
      else
        DateTime.now
      end
    end


  end

  class Job
    def initialize(relevant_info)
      @ri = relevant_info
    end
    def call(job)
      notify_about(@ri)
    end
  end




end
