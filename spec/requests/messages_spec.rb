require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let!(:user)   { create :user }
  before(:each) { sign_in user }

  describe 'POST /create', js: true do
    let!(:room) { create :room }

    context 'with valid params' do
      let(:rooms) { create_list(:room, 3) }
      let(:users) { create_list(:user, 3) }
      let(:params) { { message: { body: build(:message).body, rooms_ids: room.id } } }
      let(:multiple_params) do
        { message: { body: build(:message).body, rooms_ids: rooms.pluck(:id), users_ids: users.pluck(:id) } }
      end

      it 'create a new message' do
        expect { post messages_path(**params, format: :turbo_stream) }.to change(Message, :count).by(1)
      end

      it 'create 6 new message' do
        expect { post messages_path(**multiple_params, format: :turbo_stream) }.to change(Message, :count).by(6)
      end

      it 'return status 204' do
        post messages_path(**params, format: :turbo_stream)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with empty params' do
      let(:params) { { message: { body: '', rooms_ids: room.id } } }

      it 'not create a new room' do
        expect { post messages_path(**params, format: :turbo_stream) }.to change(Message, :count).by(0)
      end

      it 'return status 204' do
        post messages_path(**params, format: :turbo_stream)
        expect(response).to have_http_status(:ok)
      end
    end

    feature 'a message is created', js: true do
      let!(:messages_selector) { "#room_#{room.id}_messages [id^='message_']" }

      scenario 'and turbo_frame add message' do
        visit root_path
        page.find("a[href='#{room_path(room)}']").click

        expect(page).to have_css '.room_content h3'
        expect(page).to have_css '.room_content h3', text: room.title

        messages_count = page.all(messages_selector).count

        page.find('input#message_body').set build(:message).body
        page.find('input[value="Send message"]').click

        expect(page.all(messages_selector).count).to eq messages_count + 1
      end

      scenario 'and turbo_stream add message' do
        visit root_path
        page.find("a[href='#{room_path(room)}']").click

        expect(page).to have_css '.room_content h3'
        expect(page).to have_css '.room_content h3', text: room.title

        messages_count = page.all(messages_selector).count

        new_window = open_new_window
        within_window new_window do
          visit root_path
          page.find("a[href='#{room_path(room)}']").click
          page.find('input#message_body').set build(:message).body
          page.find('input[value="Send message"]').click
        end

        expect(page.all(messages_selector).count).to eq messages_count + 1
      end
    end
  end

  describe 'GET /new' do
    feature 'when user clicks create_multiple_message link', js: true do
      scenario 'turbo frame loads new multiple_message form' do
        visit root_path
        click_link 'new_multiple_message'

        expect(page).to have_field('message_users_ids')
        expect(page).to have_field('message_rooms_ids')
        expect(page).to have_field('message_body')
      end
    end
  end
end
