require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  let!(:user)   { create :user }
  before(:each) { sign_in user }

  describe 'GET /index' do
    it 'return valid answer' do
      get rooms_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('<turbo-frame id="new_room_frame"')
      expect(response.body).to include('<turbo-frame id="current_room_frame"')
    end

    feature 'a room is added', js: true do
      let!(:room) { create(:room) }
      let!(:new_room) { build(:room) }

      scenario 'and turbostream updates select' do
        visit root_path

        expect(page).to     have_css '#rooms a', text: room.title
        expect(page).not_to have_css '#rooms a', text: new_room.title

        click_link 'new_room'
        page.find('#room_title').set new_room.title
        page.find('input[value="Create Room"]').click

        expect(page).to have_css '#rooms a', text: room.title
        expect(page).to have_css '#rooms a', text: new_room.title
      end
    end
  end

  describe 'GET /new' do
    feature 'when user clicks create_room link', js: true do
      scenario 'turbo frame loads new room form' do
        visit root_path

        expect(page).not_to have_field('room_title')
        expect(page).to have_selector('#rooms')

        click_link 'new_room'

        expect(page).to have_field('room_title')
        expect(page).to have_selector('#rooms')
      end
    end
  end

  describe 'POST /create', js: true do
    context 'with valid params' do
      let(:params) { { room: { title: 'title' } } }

      it 'create a new room' do
        expect { post rooms_path(**params, format: :turbo_stream) }.to change(Room, :count).by(1)
      end

      it 'return status 200' do
        post rooms_path(**params, format: :turbo_stream)

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq Mime[:turbo_stream]
      end
    end

    context 'with empty params' do
      let(:params) { { room: { title: '' } } }

      it 'not create a new room' do
        expect { post rooms_path(**params, format: :turbo_stream) }.to change(Room, :count).by(0)
      end

      it 'return status 200' do
        post rooms_path(**params, format: :turbo_stream)

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq Mime[:turbo_stream]
      end
    end
  end

  describe 'GET /show' do
    describe 'for users room' do
      let!(:room) { create(:room) }

      feature 'when user click on room link', js: true do
        scenario 'turbo frame loads data for current_room_frame' do
          visit root_path

          expect(page.body).to include('<turbo-frame id="current_room_frame"')
          expect(page).not_to have_selector('.room_content h3')

          click_link href: room_path(room)

          expect(page).to have_css '.room_content h3', text: room.title
        end
      end
    end

    describe 'for user room' do
      let!(:user_1) { create(:user) }

      context 'when user_room does not exist' do
        it 'should create a new room' do
          expect { get room_path(create(:user), type: :user) }.to change(Room, :count).by(1)
        end
      end

      context 'when user_room exist' do
        before { get room_path(user_1, type: :user) }

        it 'should not create a new room' do
          expect { get rooms_path(user_1, type: :user) }.to change(Room, :count).by(0)
        end
      end

      feature 'when user click on user_room link', js: true do
        scenario 'turbo frame loads data for current_room_frame' do
          visit root_path

          expect(page.body).to include('<turbo-frame id="current_room_frame"')
          expect(page).not_to have_selector('.room_content h3')

          click_link href: room_path(user_1, type: :user)

          expect(page).to have_css '.room_content h3', text: user_1.nickname
        end
      end
    end
  end
end
