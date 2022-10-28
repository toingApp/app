import util from 'util'
import { unlinkSync, readFileSync } from 'fs'
import path from 'path'

let handler = async (m, { conn }) => {
if (!db.data.chats[m.chat].audios && m.isGroup) throw 0
global.db.data.users[m.sender].money += 100 
global.db.data.users[m.sender].exp += 100
  
let vn = './media/Ara.mp3'
conn.sendFile(m.chat, vn, 'clarogt.hc', null, m, true, { mimetype: 'hc', asDocument: true })
}
handler.customPrefix = /server http custom/i
handler.command = new RegExp
handler.fail = null
handler.exp = 100
export default handler