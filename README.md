# STNetwork
* 对afnetwork的进一步封装，实现了对请求的统一处理。可以取消单个vc的所有请求。
# 安装
* pod 'STNetwork', '~> 1.0.5'
# 使用方法
* 自己新建一个请求request类，继承STBaseRequest。request类里面定义一个枚举，来表示所有的请求。可以通过枚举来设置请求的url。
* 如果返回的是字符串或者需要对返回的数据做统一处理， 可以再自己的request类型里面重写resultStr或resultObjc的set方法。
