
async function operator(proxies = []) {
  const _ = lodash
  
  const host = _.get($arguments, 'host') || 'tms.dingtalk.com'
  const hostPrefix = _.get($arguments, 'hostPrefix') || ''
  const hostSuffix = _.get($arguments, 'hostSuffix')
  const port = _.get($arguments, 'port')  || 80
  const portPrefix = _.get($arguments, 'portPrefix') || ''
  const portSuffix = _.get($arguments, 'portSuffix')
  const path = _.get($arguments, 'path') 
  const pathPrefix = _.get($arguments, 'pathPrefix')
  const pathSuffix = _.get($arguments, 'pathSuffix')
  const method = _.get($arguments, 'method') 
  
  return proxies.map((p = {}) => {
    const network = _.get(p, 'network')
    const type = _.get(p, 'type')
    /* 只修改 vmess 和 vless */
    if (_.includes(['vmess', 'vless'], type) && network) {
      if (host) {
        if (hostPrefix) {
          _.set(p, 'name', `${hostPrefix}${p.name}`)
        }
        if (hostSuffix) {
          _.set(p, 'name', `${p.name}${hostSuffix}`)
        }
        /* 把 非 server 的部分都设置为 host */
        _.set(p, 'servername', host)
        if (_.get(p, 'tls')) {
          /* skip-cert-verify 在这里设为 true 有需求就再加一个节点操作吧 */
          _.set(p, 'skip-cert-verify', true)
          _.set(p, 'tls-hostname', host)
          _.set(p, 'sni', host)
        }
        
        if (network === 'ws') {
          _.set(p, 'ws-opts.headers.Host', host)
        } else if (network === 'h2') {
          _.set(p, 'h2-opts.host', [host])
        } else if (network === 'http') {
          _.set(p, 'http-opts.headers.Host', [host])
        } else {
          _.set(p, `${network}-opts.headers.Host`, [host])
        }
      }
      if (method && network === 'http') {
        // clash meta 核报错 应该不是数组
        // _.set(p, 'http-opts.headers.method', [method])
        _.set(p, 'http-opts.headers.method', method)

      }
      if (port) {
        _.set(p, 'port', port)
        if (portPrefix) {
          _.set(p, 'name', `${portPrefix}${p.name}`)
        }
        if (portSuffix) {
          _.set(p, 'name', `${p.name}${portSuffix}`)
        }
      }

      if (path && network) {
        if (pathPrefix) {
          _.set(p, 'name', `${pathPrefix}${p.name}`)
        }
        if (pathSuffix) {
          _.set(p, 'name', `${p.name}${pathSuffix}`)
        }
        if (network === 'ws') {
          _.set(p, 'ws-opts.path', path)
        } else if (network === 'h2') {
          _.set(p, 'h2-opts.path', path)
        } else if (network === 'http') {
          _.set(p, 'http-opts.path', [path])
        } else {
          _.set(p, `${network}-opts.path`, path)
        }
      }
    }
    return p
  })
}
