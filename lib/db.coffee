
level = require 'level'

module.exports = (db="#{__dirname}../db") ->
  db = level db if typeof db is 'string'
  close: (callback) ->
    db.close callback
  users:
    get: (username, callback) ->
      user = {}
      db.createReadStream
        gt: "users:#{username}:"
      .on 'data', (data) ->
        [_, username, key] = data.key.split ':'
        user.username ?= username
        user[key] = data.value
      .on 'error', (err) ->
        callback err
      .on 'end', ->
        callback null, user
    set: (username, user, callback) ->
      ops = for k, v of user
        continue if k is 'username'
        type: 'put'
        key: "users:#{username}:#{k}"
        value: v
      db.batch ops, (err) ->
        callback err
    del: (username, callback) ->
      # TODO

###
levelup = require 'levelup'
db = levelup "#{__dirname}../db"

module.exports =
  users:
    get:(user_id) ->
    ###
       ###
       db.createReadStream(gt:"users:#{user_id}:X")
       .on('data', function (data) {
         console.log(data.key, '=', data.value)
       })
       .on('error', function (err) {
         console.log('Oh my!', err)
       })
       .on('close', function () {
         console.log('Stream closed')
       })
       .on('end', function () {
         console.log('Stream closed')
       })
       ###
###
       db.createReadStream(
         gt:"users:#{user_id}:",
         lt:"users:#{user_id}:X"
       .on 'data', (data) ->
         user[data.key] = data.value
       .on 'error', (err) ->
         callback err
       .on 'end', ->
         callback null, user

    set:(user_id, user, callback) ->
      # Serialize user (object)
      #user = JSON.stringify user
      ops = []
      for k, v of user
        ops.push
          type: 'put',
          key: "users:#{user_id}:#{k}",
          value: v

      db.put user_id, user, (err) ->
        callback err

    del:(user_id) ->
      #TODO


module.exports =
  users:
    get:(username) ->
       db.createReadStream(
         gt:"users:#{username}:",
         lt:"users:#{username}:X"
       .on 'data', (data) ->
         user[data.key] = data.value
       .on 'error', (err) ->
         callback err
       .on 'end', ->
         callback null, user

    set:(username, user, callback) ->
      # Serialize user (object)
      #user = JSON.stringify user
      ops = []
      for k, v of user
        ops.push
          type: 'put',
          key: "users:#{username}:#{k}",
          value: v

      db.put user_id, user, (err) ->
        callback err

    del:(user_id) ->
      #TODO

###

###
SET
Pb1:
User c'est un objet: comment sérialize c'est une structure sauf si levelup le fait pour nous (pas sur)
doit le faire nous même. --> Lire dans la doc
--> Avec le stringify: pb stocke tous, si veut changer 1 champs, modifie tous ! écrase les autres données
--> Devra faire un get (stocker les anciennes), un set et re un get...
--> Clé plus adapté ID + méthode pour éviter cela : utilise db.batch (voir doc)

"user:#{user_id}:#{k}"
users: = préfixe qui définie l'ensemble = namespace user contenant
  user_id = id de user
  méthode k : clé de chaque donnée du tableau value (car user value est un objet et k et la clé pour chaque value de user)


SYNTAX
for a, i in users --> in pour list
for k, v of users --> of pour parcourir les propriétés de l'object
Ex:
user =
  username: 'david',
    password: 'xxx'
--> on aurra donc k : username & v : david

GET
createReadtream
--> utilise pour lire
Trouver user_id: problème notre clé c'est de la forme "users:user_id:k"
#Note: user_id existe pas: doit dire donne moi tous ce qui commence par users:user_id
# Utilise greater Than

###
