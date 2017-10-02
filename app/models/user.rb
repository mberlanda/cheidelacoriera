# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :fans, inverse_of: :user, dependent: :nullify

  ROLES = %w[fan admin].freeze
  STATUSES = %w[active pending].freeze

  def to_s
    email
  end
end
