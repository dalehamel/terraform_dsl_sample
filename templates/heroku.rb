require 'terraform_dsl'

class HerokuTestApp < Terraform::StackTemplate
  variable(:appname){ default 'default' }
  variable(:region){ default 'us' }
  variable(:stack){ default 'cedar' }
  variable(:organization){ default 'shopify' }
  variable(:mysqlplan){ default 'ignite' }
  variable(:pgplan){ default 'hobby-dev' }

  provider('heroku') {}

  # Create a new Heroku app
  resource 'heroku_app', :default do
    name   var(:appname)
    region var(:region)
    stack  var(:stack)

    organization {
      name var(:organization)
    }

   # config_vars {  # App configuration can be loaded entirely from ejson, or stack.yml variables!!!
   #     FOOBAR = "baz"
   # }
  end

  # Set up mysql cleardb with configurable plan
  resource 'heroku_addon', :mysqldb do
    app  value_of('heroku_app','default','name')
    plan "cleardb:#{var(:mysqlplan)}"
  end

  # Set up mysql cleardb with configurable plan
  resource 'heroku_addon', :postgresdb do
    app  value_of('heroku_app','default','name')
    plan "heroku-postgresql:#{var(:pgplan)}"
  end

end
