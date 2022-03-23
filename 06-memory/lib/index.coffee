fs = require 'fs'


exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  fs.readFile "#{__dirname}/../data/geo.txt", 'utf8', (err, data) ->
    if err then return cb err
    counter = 0
    while (data.indexOf '\n') != -1
      line = data.substr 0, data.indexOf '\n'
      data = data.replace line + '\n', ''
      # data = data.slice 0, data.indexOf '\n'
      line = line.split '\t'
      # # GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
      # # line[0],       line[1],       line[3]

      if line[3] == countryCode then counter += +line[1] - +line[0]
      
    cb null, counter