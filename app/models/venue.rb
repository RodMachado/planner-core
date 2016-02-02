class Venue < ActiveRecord::Base

  include RankedModel

  attr_accessible :lock_version, :name, :sort_order

  validates_presence_of :name

  has_one :address, dependent: :delete
  has_one(
    :postal_address,
    through: :address,
    source: :addressable,
    source_type: 'PostalAddress'
  )
  has_one :publication, foreign_key: :original_id, as: :original
  has_one(
    :published,
    through: :publication,
    source: :published,
    source_type: 'PublishedVenue'
  )
  has_many :rooms, dependent: :destroy

  accepts_nested_attributes_for :postal_address

  audited allow_mass_assignment: true

  ranks :sort_order

  default_scope order('venues.sort_order asc, venues.name asc')

end
