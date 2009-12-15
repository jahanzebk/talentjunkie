# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_jobs_session',
  :secret      => 'bb97ddfb0d311e5c49d00925211d2404f758fea9b5e1f44fc15d0cc9f78f221668d1c718d2b377a8253b1a057c818d2f7467c11dbc13450b5de7bfb76e8fad29'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
