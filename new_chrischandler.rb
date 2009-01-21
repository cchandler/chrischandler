# run very flat apps with merb -I <app file>.

# Uncomment for DataMapper ORM
# use_orm :datamapper

# Uncomment for ActiveRecord ORM
# use_orm :activerecord

# Uncomment for Sequel ORM
# use_orm :sequel


#
# ==== Pick what you test with
#

# This defines which test framework the generators will use.
# RSpec is turned on by default.
#
# To use Test::Unit, you need to install the merb_test_unit gem.
# To use RSpec, you don't have to install any additional gems, since
# merb-core provides support for RSpec.
#
# use_test :test_unit
use_test :rspec

#
# ==== Choose which template engine to use by default
#

# Merb can generate views for different template engines, choose your favourite as the default.

use_template_engine :erb
# use_template_engine :haml

Merb::Config.use { |c|
  c[:framework]           = { :public => [Merb.root / "public", nil] }
  c[:session_store]       = 'none'
  c[:exception_details]   = true
	c[:log_level]           = :debug # or error, warn, info or fatal
  c[:log_stream]          = STDOUT
  # or use file for loggine:
  # c[:log_file]          = Merb.root / "log" / "merb.log"

	c[:reload_classes]   = false
	c[:reload_templates] = false
}

require 'merb-helpers'
require 'merb-assets'

Merb::Router.prepare do
  match('/').to(:controller => 'welcome', :action =>'index')
end

class Welcome < Merb::Controller
  def index
    render
  end
end