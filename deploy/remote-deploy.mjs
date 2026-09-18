// 临时部署辅助脚本：SSH 探测 / 执行远程命令 / SFTP 上传
import { Client } from 'ssh2'
import fs from 'fs'

const HOST = '111.229.225.115'
const USER = 'root'
const PASSWORD = process.env.DEPLOY_PWD

const mode = process.argv[2] // probe | exec | put
const arg3 = process.argv[3]

const conn = new Client()
conn.on('ready', () => {
  if (mode === 'probe') {
    const cmd = `echo SSH_OK; node -v 2>&1; npm -v 2>&1; pm2 -v 2>&1; mysql --version 2>&1; ls -d /usr/service/nestAdmin /www 2>/dev/null; echo ---; df -h / | tail -1`
    conn.exec(cmd, (err, stream) => {
      if (err) { console.error('EXEC_ERR', err.message); conn.end(); process.exit(1) }
      let out = ''
      stream.on('data', (d) => (out += d.toString()))
      stream.stderr.on('data', (d) => (out += d.toString()))
      stream.on('close', () => { console.log(out); conn.end() })
    })
  } else if (mode === 'exec') {
    conn.exec(arg3, (err, stream) => {
      if (err) { console.error('EXEC_ERR', err.message); conn.end(); process.exit(1) }
      let out = ''
      stream.on('data', (d) => (out += d.toString()))
      stream.stderr.on('data', (d) => (out += d.toString()))
      stream.on('close', (code) => { console.log(out); console.log(`EXIT:${code}`); conn.end(); process.exit(code ? 1 : 0) })
    })
  } else if (mode === 'put') {
    const [local, remote] = [process.argv[3], process.argv[4]]
    conn.sftp((err, sftp) => {
      if (err) { console.error('SFTP_ERR', err.message); conn.end(); process.exit(1) }
      sftp.fastPut(local, remote, (err2) => {
        if (err2) { console.error('PUT_ERR', err2.message); conn.end(); process.exit(1) }
        console.log(`UPLOADED ${local} -> ${remote}`)
        conn.end()
      })
    })
  }
})
conn.on('error', (e) => {
  console.error('SSH_ERR', e.level || '', e.message)
  process.exit(1)
})
conn.connect({ host: HOST, port: 22, username: USER, password: PASSWORD, readyTimeout: 15000 })
