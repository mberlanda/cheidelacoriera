# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :fans, inverse_of: :user, dependent: :nullify
  has_many :reservations, inverse_of: :user, dependent: :nullify

  ROLES = %w[fan admin].freeze
  STATUSES = %w[active pending].freeze

  def to_s
    email
  end

  def admin?
    role == 'admin'
  end

  def active?
    status == 'active'
  end

  def visible_users
    admin? ? User.all : [self]
  end

  def allowed_fans
    admin? ? Fan.all : fans
  end
end
