assert = require 'assert'
WordCount = require '../lib'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word, characters and bytes', (done) ->
    input = 'test'
    expected = words: 1, lines: 1, characters: 4, bytes: 4
    helper input, expected, done

  it 'should count words in a phrase, characters and bytes', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1, characters: 20, bytes: 20
    helper input, expected, done

  it 'should count quoted characters as a single word, characters and bytes', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1, characters: 19, bytes: 19
    helper input, expected, done

  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!

  it 'should count a phrase, characters and bytes', (done) ->
    input = 'The quick brown fox jumps over the lazy dog '
    expected = words: 9, lines: 1, characters: 44, bytes: 44
    helper input, expected, done

  it 'should count quoted characters as a single word, lines, characters and bytes', (done) ->
    input = 'The\n"Quick Brown Fox"\njumps over the lazy dog '
    expected = words: 7, lines: 3, characters: 46, bytes: 46
    helper input, expected, done

  it 'should count camel cased words, lines, characters and bytes', (done) ->
    input = 'TheQuick\nBrownFox\njumps\nOverTheLazy\ndog '
    expected = words: 9, lines: 5, characters: 40, bytes: 40
    helper input, expected, done
