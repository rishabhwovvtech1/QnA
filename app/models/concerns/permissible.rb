module Permissible

  extend ActiveSupport::Concern

  included do

    # To check if an object have permission to operate or not just pass permission(s) as arguments.
    def can?(*permissions_to_check)
      check_permissions(*permissions_to_check)
    end

    # Define methods dynamically using key value pairs in PERMISSIONS
    # For example pair => { "ViewUsers" => "view_users" }
    # It will create a methods like can_view_users? from the values in the PERMISSIONS hash.
    # These methods will
    #                       => Return true or false depending on permissions assigned to admin
    #                       => And if Admin have Manage permission then it will assume that it will also have View Permission of same behaviour.
    #                       => so if we have admin.permissions # => ["ManageUsers"]
    #                          admin.can_view_users?   => true
    #                          admin.can_manage_users? => true
    #                          admin.can_view_xyz?     => false
    #                          admin.can_manage_xyz?   => false
    #
    # Just need to make sure that the PERMISSIONS has is defined correctly. Refer permissions.rb for details                          
    #
    if ActiveRecord::Base.connection.data_source_exists? 'permissions'
      Permission.all.each do |permission|
        define_method "can_#{ permission.code }?" do
          can?(permission.code)
        end
      end
    end

    private
      def check_permissions(*permissions_to_check)
        return true if self.super_admin?
        raise "No permission provided" if permissions_to_check.blank?
        (permissions_to_check - available_permissions).blank?
      end


      def available_permissions
        permissions = self.permission_codes
        permissions.each do |permission|
          if permission.split('_').first == 'manage'
            permissions.push(permission.gsub('manage', 'view'))
          end
        end
      end
  end
end