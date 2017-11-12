# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :reservations, inverse_of: :user, dependent: :nullify

  ROLES = %w[fan admin].freeze
  STATUSES = %w[active pending].freeze

  # validates :phone_number, format: { with: /\A[x\d\(\)\s\-\.]{5,}\z/ }

  scope :actives, ->() { where(status: :active) }
  scope :to_notify, ->() { where(activation_date: nil) }

  def to_s
    email
  end

  def full_name
    "#{last_name} #{first_name}"
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
end
