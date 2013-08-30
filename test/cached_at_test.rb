require 'test_helper'

def key_for(object, key)
  timestamp = object.send(key).utc.to_s(:number)
  "#{object.class.model_name.cache_key}/#{object.id}-#{timestamp}"
end

describe CachedAt do
  describe '#cache_key' do
    let(:cache_key) { user.cache_key }

    context 'new record' do
      let(:user) { User.new }
      it { cache_key.must_equal 'users/new' }
    end

    context 'existing record' do
      let(:user) { User.create }
      before { user.cached_at = Time.now + 1.minute }

      it { cache_key.wont_equal key_for(user, :updated_at) }
      it { cache_key.must_equal key_for(user, :cached_at) }
    end

    context 'cached_at nil' do
      let(:user) { User.create }
      before { user.cached_at = nil }

      it { cache_key.must_equal "users/#{user.id}" }
    end
  end

  describe '#set_cached_at' do
    context 'creating record' do
      let(:user) { User.new }

      it 'sets cached_at' do
        user.cached_at.must_be_nil
        user.save
        user.cached_at.wont_be_nil
      end
    end

    context 'updating record' do
      let(:user) { User.create }

      before { @old_cached_at = user.cached_at }

      it 'updates cached_at' do
        user.update_attribute(:name, 'Bob')
        user.cached_at.wont_equal @old_cached_at
      end

      it 'does not update the cached_at when nothing has changed' do
        user.save
        user.cached_at.must_equal @old_cached_at
      end
    end
  end

  describe 'Associations' do
    let(:user) { User.create }

    context 'create association' do
      let(:post) { Post.new user: user }

      before do
        @old_cached_at  = user.cached_at
        @old_updated_at = user.updated_at
        post.save
      end

      it 'updates the cached_at' do
        user.cached_at.wont_equal @old_cached_at
      end

      it 'does not update the updated_at' do
        user.updated_at.must_equal @old_updated_at
      end
    end

    context 'update association' do
      let(:post) { Post.create user: user }

      before do
        @old_cached_at  = user.cached_at
        @old_updated_at = user.updated_at
        post.update_attribute(:title, 'New')
      end

      it 'updates the cached_at' do
        user.cached_at.wont_equal @old_cached_at
      end

      it 'does not update the updated_at' do
        user.updated_at.must_equal @old_updated_at
      end
    end
  end

  describe 'Model.cache_key' do
    subject { User.cache_key }

    it { subject.must_equal "User-#{User.maximum(:cached_at).to_i}" }

    context 'when no record exist' do
      before { User.destroy_all }
      it { subject.must_equal "User-0" }
    end
  end
end
