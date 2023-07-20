require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let!(:user)   { create :user }
  before(:each) { sign_in user }

  describe 'POST /create', js: true do
    let!(:room) { create :room }

    context 'with valid params' do
      let(:params) { { message: { body: build(:message).body } } }

      it 'create a new room' do
        expect { post room_messages_path(room, **params, format: :turbo_stream) }.to change(Message, :count).by(1)
      end

      it 'return status 204' do
        post room_messages_path(room, **params, format: :turbo_stream)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with empty params' do
      let(:params) { { message: { body: '' } } }

      it 'not create a new room' do
        expect { post room_messages_path(room.id, **params, format: :turbo_stream) }.to change(Message, :count).by(0)
      end

      it 'return status 204' do
        post room_messages_path(room, **params, format: :turbo_stream)
        expect(response).to have_http_status(:no_content)
      end
    end

    feature 'a message is created', js: true do
      let!(:messages_selector) { "#room_#{room.id}_messages [id^='message_']" }

      scenario 'and turbostream add message' do
        visit root_path
        page.find("a[href='#{room_path(room)}']").click

        expect(page).to have_css '.room_content h3'
        expect(page).to have_css '.room_content h3', text: room.title

        messages_count = page.all(messages_selector).count

        page.find('input#message_body').set build(:message).body
        page.find('input[value="Send message"]').click

        expect(page.all(messages_selector).count).to eq messages_count + 1
      end
    end

  end
end
