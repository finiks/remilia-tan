# Description:
#   Searches jisho for a given word or sentence
#
# Commands:
#   hubot jisho me <phrase> - Searches for a translation for <phrase> on jisho.

module.exports = (robot) ->
  auth = (cb) ->
    grant_data = JSON.stringify({
      grant_type: "client_credentials",
      client_id: process.env.ANILIST_CLIENT_ID,
      client_secret: process.env.ANILIST_CLIENT_SECRET
    })

    robot.http("https://anilist.co/api/auth/access_token")
      .header('Content-Type', 'application/json')
      .post(grant_data) (err, res, auth_body) ->
        auth_data = JSON.parse auth_body
        token = auth_data["access_token"]
        cb(token)

  robot.respond /anime search (.*)/i, (msg) ->
    cb = (token) ->
      robot.http("https://anilist.co/api/anime/search/#{msg.match[1]}?access_token=#{token}")
        .get() (err, res, body) ->
          data = JSON.parse body
          msg.send "#{anime['title_romaji']} (#{anime['type']}) ID: #{anime['id']}" for key, anime of data
    auth(cb)

