require "rubygems"
require "httparty"
require "ruby-debug"
require 'json'

module Pomotrap

  class Client
    include HTTParty
    base_uri "http://localhost:3000"
    format :json

    attr_reader :api_token

    def initialize(token, debug=false)
      @api_token = token
      self.class.debug_output if debug
    end


    def display
      todays_sheet = find_or_create_to_do_today
    end

    def display_stubbed
      result = JSON.parse("{\"tasks\": [ { \"id\":\"123456\", \"priority\":\"1\", \"description\":\"Task one.\", \"pomodoros\":\"0\", \"interruptions\":\"0\" }, { \"id\":\"123456\", \"priority\":\"2\", \"description\":\"Task two.\", \"pomodoros\":\"0\", \"interruptions\":\"0\" }] }")
    end


    def find_or_create_to_do_today
      today = date("today")
      puts today
      get "to_do_today/#{today}", {:params => {}}
    end

    def create_task(params={})
    end

    def fire_pomodoro(params={})

      # 1) having task priority, get task id
      # 2) assign new pomodoro to task
      # 3)

      post 'to_do_todays', {:to_do_today => params} # TODO fixme
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

end
