apt_update 'Update apt cache' do
  action :update
end

package 'apache2'


