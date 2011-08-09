class Product < ActiveRecord::Base
  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01, :message => 'The number has to be greater than 0.01'}
  validates :title, :uniqueness => true
  validates :image_url, :format => {
    :with => %r{\.(gif|jpg|png)}i,
    :message => 'must be a url for gif, jpg or png image.'
  }
  default_scope :order => "title"
  
  has_many :line_items
  
  before_destroy :ensure_not_reference_by_any_line_item
  
  def ensure_not_reference_by_any_line_item
    if line_item.size.zero?
      return true
    else
      error[:base] << 'line item present'
      return false
    end
  end
end
