class FbUser < User
    validates_presence_of :facebook_uid
end