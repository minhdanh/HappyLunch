module SlackMessageServices
  class Base
    def self.send_message(content)
      connection = Faraday.new(url: "https://slack.com/api/")
      response = connection.get "chat.postMessage",
                            channel: "#lunch", token: ENV["SLACK_TOKEN"],
                            text: content, mrkdwn: true,
                            username: ENV["SLACK_BOT_NAME"], link_names: 1,
                            icon_emoji: ENV["SLACK_BOT_EMOJI"]
      data = JSON.parse(response.body)
      data["ok"]
    end
  end
end
