const fs = require('fs')
const Discord = require('discord.js')
const client = new Discord.Client()
const token = ""
const channelid = ""

client.on('ready', () => {
  console.log('Bot is ready!');
  client.user.setActivity('people chat.', { type: 'WATCHING'});
  newone(client);
})

function newone(client) {
  if (fs.existsSync('data.txt')) {
    msg = fs.readFileSync('data.txt').toString();
    fs.unlink('data.txt', function (err) {
    if (err) throw err;
    });
    client.channels.get(channelid).send(msg)
  }
  setTimeout(function(){
    newone(client);
  }, 1000)
}

client.login(token)