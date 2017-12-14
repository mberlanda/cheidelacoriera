# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :reservations, inverse_of: :user, dependent: :nullify

  after_update :send_rejection_email

  ROLES = %w[fan preferred admin].freeze
  STATUSES = %w[active pending rejected].freeze

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

  def rejected?
    status == 'rejected'
  end

  def visible_users
    admin? ? User.all : [self]
  end

  def send_rejection_email
    UserMailer.rejection_email(self).deliver_later if status_changed? && rejected?
  end
end
