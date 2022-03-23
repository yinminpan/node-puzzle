through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 1
  characters = 0
  bytes = 0

  transform = (chunk, encoding, cb) ->
    characters = chunk.length
    bytes = Buffer.byteLength chunk, "utf-8"
    lines = (chunk.split '\n').length
    chunk = chunk.replace /\n/g, ' '
    chunk = chunk.replace /[A-Z]/g, (' $&'.toLowerCase())
    chunk = chunk.trim().split '"'

    if chunk.length > 2
      for word, i in chunk
        if i !=0 && i != chunk.length - 1 && i % 2 == 1
          chunk[i] = 'quote'

    chunk = chunk.join ' '
    tokens = (chunk.split ' ').filter (token) -> token.trim() != ''
    words = tokens.length
    return cb()

  flush = (cb) ->
    this.push {words, lines, characters, bytes}
    this.push null
    return cb()

  return through2.obj transform, flush
