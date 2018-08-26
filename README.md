# 1. README

<!-- TOC -->

- [1. README](#1-readme)
- [2. migrate日志](#2-migrate日志)
    - [2.1. 第一个版本](#21-第一个版本)
        - [2.1.1. Catg](#211-catg)
        - [2.1.2. TagKey](#212-tagkey)
        - [2.1.3. Area](#213-area)
        - [2.1.4. Admin](#214-admin)
    - [2.2. 第二个版本](#22-第二个版本)
        - [2.2.1. Attachment](#221-attachment)
        - [2.2.2. sns](#222-sns)
    - [2.2. 第三个版本](#22-第三个版本)
        - [device user](#device-user)
        - [2.2.2. wuxin_dicts五行字典](#222-wuxin_dicts五行字典)
        - [2.2.2. bbnames  小孩名称](#222-bbnames--小孩名称)
        - [bbname_results 取名的结果](#bbname_results-取名的结果)
        - [](#)
- [3. 配置](#3-配置)
    - [3.1. sidekiq配置](#31-sidekiq配置)
    - [3.2. redis配置](#32-redis配置)
    - [3.3. elasticsearch配置](#33-elasticsearch配置)
    - [3.4. pundit配置](#34-pundit配置)
    - [3.5. 附件表：attachement](#35-附件表attachement)
    - [3.6. db:seed_fu](#36-dbseed_fu)

<!-- /TOC -->

# 2. migrate日志

## 2.1. 第一个版本

### 2.1.1. Catg

```sh
rails g model Catg \
    name:string:uniq \
    en_name:string \
    seq:integer \
    status:integer{1} \
    ext:text

rails g scaffold_controller \
    Backend::Catg \
    name:string \
    seq:integer \
    --model-name=Catg \
    -f

```

### 2.1.2. TagKey

```sh
# 无用
rails g model TagKey \
    name:string:uniq \
    en_name:string \
    seq:integer \
    status:integer{1} \
    catgs:references \
    ext:text
rails d model TagKey

rails g scaffold_controller \
    Backend::TagKey \
    name:string \
    catg_id:association
    seq:integer \
    --model-name=TagKey \
    -f
```

### 2.1.3. Area

```sh
rails g model Area \
    name:string \
    code:string \
    zone:integer \
    seq:integer  \
    parent_id:integer:index \
    depth:integer:index \
    lft:integer:index \
    rgt:integer:index \
    children_count:integer:index \
    status:integer{1}

rails g scaffold_controller \
    Backend::Area \
    name:string \
    zone:integer \
    seq:integer \
    --model-name=Area \
    -f
```

### 2.1.4. Admin


```sh 
rails g scaffold_controller \
    Backend::Admin \
    name:string \
    email:string \
    username:string \
    password:string \
    password_confirmation:string \
    --model-name=Admin \
    -f

rails g migration addNameToAdmins name:string 
rails g migration addUsernameToAdmins username:string:uniq
rails g migration addStatusToAdmins status:integer{2}
rails g migration addRoleToAdmins role:integer

rails g migration addContactsToAdmins phone:string:uniq tel:string qq:string fax:string desc:text

```

## 2.2. 第二个版本


### 2.2.1. Attachment

```sh
# http://caok1231.com/rails/2012/08/31/file-uploading-by-carrierwave.html
# https://richonrails.com/articles/allowing-file-uploads-with-carrierwave
rails g model Attachment \
    file_name:string \
    content_type:string \
    file_size:string \
    attachmentable_type:string \
    attachmentable_id:integer \
    attachment:string
rails g uploader Attachment

```

### 2.2.2. sns

```sh
# 发前绑定的微信公众号
rails g migration addSnsIdToAdmins sns_id:integer

rails g model SnsAccount \
    admin_id:integer:index \
    platform:integer \
    scope:string \
    union_id:string:index \
    openid:string:index \
    access_token:string \
    expires_in:integer \
    authorized_at:datetime \
    refresh_token:string \
    user_data:text \
    -f 
# expire_in access_token过期的时间
# authorized_at 授权的日期
# raw_data 社会化用户的信息

```

## 2.2. 第三个版本

### device user

```sh

bundle exec rails g devise user
bundle exec rails db:migrate
bundle exec rails generate devise:views users
bundle exec rails generate devise:controllers users

vim routes.rb
  devise_for :users, controllers: {
    sessions:           'users/sessions',
    passwords:          'users/passwords',
    registrations:      'users/registrations',
    unlocks:            'users/unlocks',
  }

bundle exec rails g migration addBasicAttrToUsers name:string username:string:uniq phone:string status:integer{2} role:integer
bundle exec rails db:migrate
```

### 2.2.2. wuxin_dicts五行字典

| 属性 | 名称 | 类型 | 备注 |
| - | - | - | - |
| 汉字 | name | varchar(2) | 索引 |
| 拼音 | pingyin | varchar(10) | |
| 拼音 | pingyin2 | varchar(10)| 带声调的 |
| 所属五行 | wuxin | varchar(2) | |
| 笔画数 | stroke | int | |
| 是否繁体 | traditional | int(1) | default(0) |
| 性别倾向 | sexual | int(1) | |


### 2.2.2. bbnames  小孩名称

每个人可以建多个名字项目，按生日来计


| 属性 | 名称 | 类型 | 备注 |
| - | - | - | - |
| 所属地区 | area_id | int | 外键 |
| 所属用户 | user_id | int | 外键 |
| 姓氏 | first_name | varchar(10) | |
| 生辰 | birthday | varchar(20) | yyyy-mm-dd hh:MM:00, 索引 |
| 性别倾向 | sexual | int(1) | |
| 名字类型 |  | int(1) | 0未知 1单字 2双字 |
| 喜用五行 | hobby_wuxin | int| 限制五行的选择，金木水火地 - 0x11111, 0表示不限制，首尾字只能从限制五行取五行 |
| 首次五行 | first_wuxin | int | 金木水火地 - 0x11111, 0表示不限制 |
| 尾字五行 | last_wuxin | int | 金木水火地 - 0x11111, 0表示不限制 |
| 首字汉字 | first_words | varchar(200) | 限制用字, 空表示不限制 |
| 尾字汉字 | last_words | varchar(200) | 限制用字, 空表示不限制 |
| | | | |
| 取名状态 | status | int(2) | 0:未取名 1:已取名 |
| | | | |
| 最终名字 | last_name | varchar(10) | 最终的名字 |
| 五行评分 | wuxin_score | int | 0-100 |
| 五格评分 | wuge_score | int | 0-100 |

### bbname_results 取名的结果

| 姓氏 | first_name | varchar(10) | |



### 

# 3. 配置

## 3.1. sidekiq配置

```sh
gem 'sidekiq'
gem 'sidekiq-unique-jobs'
gem 'capistrano-sidekiq'

bundle exec rails g sidekip:worker ImportCustomers
bundle exec rails g sidekiq:worker ImportFinancials
bundle exec rails g sidekiq:worker SearchIndexer

cat > config/sidekiq.yml <<EOF
---
:concurrency: 20
:pidfile: tmp/pids/sidekiq.pid
:logfile: log/sidekiq.log
:queues:
  - [schedule, 50]
  - [search_indexer, 30]
  - [mailer, 5]
  - [default, 3]
  - [critical, 2]
EOF

bundle exec sidekiq

=======================
gem 'sidekiq-scheduler' #
# gem "sidekiq-cron", "~> 0.6.3" #

bundle exec rails g sidekiq:worker CustomerSchedule # 
cat > config/sidekiq_schdule.yml <<EOF
# :dynamic: <if true the schedule can be modified in runtime [false by default]>
# :dynamic_every: <if dynamic is true, the schedule is reloaded every interval [5s by default]>
# :enabled: <enables scheduler if true [true by default]>
# :scheduler:
  # :listened_queues_only: <push jobs whose queue is being listened by sidekiq [false by default]>

:schedule:
  CustomerScheduleWorker:
    cron: '0 * * * * *' # Runs when second = 0
    every: '45m'    # Runs every 45 minutes / 45s
    at: '3001/01/01' #
    in: 1h # pushes a sidekiq job in 1 hour, after start-up
    every: ['30s', first_in: '120s']
  # clear_leaderboards_contributors:
  #   cron: '0 30 6 * * 1'
  #   class: ClearLeaderboards
  #   queue: low
  #   args: contributors
  #   description: 'This job resets the weekly leaderboard for contributions'

EOF

require 'sidekiq-scheduler/web'

```

## 3.2. redis配置

```sh
cat > config/redis.yml.sample <<EOF
defaults: &defaults
    host: 127.0.0.1
    port: 6379
    db: 1                       # rails 缓存
    db_sidekiq: 2               # sidekiq 队列
    db_cable: 3                 # cable pub/sub
    ns_sidekiq: 'bbname:sidekiq'   # name for sidekiq

development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
EOF

cp -R config/redis.yml.sample config/redis.yml


cat > config/initializers/redis.rb <<EOF
require 'redis'
require 'redis-namespace'
require 'redis/objects'
redis_cfg = Rails.application.config_for(:redis)

redis = Redis.new(host: redis_cfg['host'], port: redis_cfg['port'], driver: :hiredis)
redis.select(redis_cfg[:db])
Redis::Objects.redis = redis
Redis.current = redis

sidekiq_url = "redis://#{redis_cfg['host']}:#{redis_cfg['port']}/#{redis_cfg['db_sidekiq']}"
Sidekiq.configure_server do |config|
  config.redis = { url: sidekiq_url, namespace: redis_cfg['ns_sidekiq'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: sidekiq_url, namespace: redis_cfg['ns_sidekiq'] }
end

EOF
```

- mac-redis
- 
```sh
brew install redis
brew tap homebrew/services
brew services [start/stop/restart] redis

https://serverfault.com/questions/731256/starting-redis-as-a-service-on-os-x-with-homebrew/760564
```

## 3.3. elasticsearch配置

```sh
https://www.sitepoint.com/full-text-search-rails-elasticsearch/
http://railscasts.com/episodes/306-elasticsearch-part-1

elasticsearch-rails

gem 'elasticsearch-model'
gem 'elasticsearch-rails'

bundle exec rails g sidekiq:worker SearchIndexer

cat > config/elasticsearch.yml.sample <<EOF
defaults: &defaults
  host: 127.0.0.1:9200

development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
EOF

cp -R config/elasticsearch.yml.sample config/elasticsearch.yml

cat > config/initializers/elasticsearch.rb <<EOF
require 'elasticsearch/rails/instrumentation'
config = Rails.application.config_for(:elasticsearch)
Elasticsearch::Model.client = Elasticsearch::Client.new host: config['host']
EOF
```

## 3.4. pundit配置

```sh
rails g pundit:install
>>>>> app/policies/application_policy.rb

rails g pundit:policy admin
>>>>>> app/policies/admin_policy.rb
rails g pundit:policy customer
>>>>>> app/policies/customer_policy.rb

rails g pundit:policy area
rails g pundit:policy catg
rails g pundit:policy branch
rails g pundit:policy customer_product
rails g pundit:policy admin_log
rails g pundit:policy financial_product

rails g pundit:policy menu
<<<<<<<
protected :index?, :show?, :create?, :new?, :update?, :edit?, :destroy?, :scope
public :admin?, :super?, :mayor?, :manager?
<<<<<<<

>>>>>> 
>>>>>> 
```

## 3.5. 附件表：attachement

```
    类型
    日志编号
    文件名
    文件路径
    大小
    上传日期
# http://caok1231.com/rails/2012/08/31/file-uploading-by-carrierwave.html
#  https://richonrails.com/articles/allowing-file-uploads-with-carrierwave
rails g model Attachment \
    file_name:string \
    content_type:string \
    file_size:string \
    attachmentable_type:string \
    attachmentable_id:integer \
    attachment:string
rails g uploader Attachment

```

## 3.6. db:seed_fu
```
rake db:seed_fu FIXTURE_PATH=path/to/fixtures
rake db:seed_fu FILTER=users,articles
```


