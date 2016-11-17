# spec/classes/init_spec.rb
require 'spec_helper'

describe 'users', :type => :define do
    describe 'super simple user hash test' do
        let :title do
            'foo'
        end
        let :params do
            {'user_hash' => { 'bar' => {'uid' => '5005', 'ensure' => 'present', 'ssh_authorized_keys' => 'somebs'}}}
        end

        it { should contain_users('foo') }
        it { should contain_user('bar').with_uid(5005) }
    end

    describe 'simple removal of user' do
        let :title do
            'foo'
        end
        let :params do
            {'user_hash' => { 'bar' => {'uid' => '5005', 'ensure' => 'absent'}}}
        end

        it { should_not contain_user('bar').without_uid(5005) }
    end

end