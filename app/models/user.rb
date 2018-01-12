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

  STATUSES.each do |s|
    define_method("#{s}?") { status == s }
    define_method("#{s}!") { update(status: s) }
    define_method("was_#{s}?") { status_was == s }
  end

  ROLES.each do |r|
    define_method("#{r}?") { role == r }
    define_method("#{r}!") { update(role: r) }
    define_method("was_#{r}?") { role_was == r }
  end

  def to_s
    email
  end

  def full_name
    "#{last_name} #{first_name}"
  end

  def form_name
    return unless last_name
    "#{last_name} | #{first_name}"
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

  def can_book?(event)
    return false unless event.bookable?
    return false if fan? && !event.everyone?
    true
  end
end
