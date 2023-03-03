# Proxy  
This project deploys xray automatically on a fresh virtual machine.

# 科学上网环境搭建  

## Step 1. 购买VPS  

VPS最好是KVM类型的，后期有一些软件或者功能依赖于此。我这里推荐一下RackNerd的虚拟机，便宜好用：https://www.racknerd.com/NewYear/

## Step 2. 购买域名

购买域名是为了配合CDN，防止VPS的IP被封。Namesilo的域名价格便宜，随便选一个即可：https://www.namesilo.com/

## Step 3. 安装宝塔面板，搭建伪网站

FQ方案一般选择TLS，使用443端口，容易被某防火墙留意到。据说该墙会做反向探测，访问一下该IP，如果获取不到正确的HTTP响应就会封端口甚至IP。搭建伪网站可以起到欺骗的目的，降低被封的几率。

## Step 4. 绑定域名到CDN  

Cloudflare提供免费的CDN服务，可以作为Proxy来转发流量。使用CDN转发时，CDN可以代理DNS解析，返回CDN的地址作为目的域名的地址。由于CDN返回的地址不是固定的，并且一般不会封CDN的IP，因此绑定域名到CDN可以极大降低被封的几率。https://www.ywbj.cc/?p=114

## Step 5. 搭建V2fly  

V2fly支持nginx+wss的方式来构建路由转发。简单来说，在VPS上用Nginx来反向代理伪网站。正常HTTP和HTTPS的请求会被伪网站所相应，而websocket的请求通过443端口被nginx代理后转发给VPS内部的V2fly监听端口。这样一来，从VPS外部看不到V2fly的存在，也很难从流量特征或者用反向探测的方式检测到梯子的存在。

[vless-nginx-wss-cdn-solution](vless-nginx-wss-cdn-solution/)提供了一个例子供参考。


## Step 6. 在本地部署V2fly客户端  

Windows下可以使用v2rayN。火狐浏览器的话可以使用插件FoxyProxy来方便切换代理。一般推荐使用白名单模式，只让白名单内的网站走代理，其他的走直连。https://www.jamesdailylife.com/new_v2rayn_c

