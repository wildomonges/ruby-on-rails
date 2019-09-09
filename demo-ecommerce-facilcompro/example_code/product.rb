# frozen_string_literal: true

class Product < ActiveRecord::Base
  searchkick synonyms: [%w[wireless bluetooth], %w[wireless inalambrico], %w[laptop notebook], %w[speaker parlante], %w[tv televisor], %w[fullhd fhd], %w[frezzer congelador], %w[celular smartphone]]
  include ProductStatusEnum
  belongs_to :sub_category
  belongs_to :tax
  belongs_to :category
  belongs_to :provider

  has_many :product_variants

  def self.get_product(id)
    Product.select(:id, :name, :tax_id).find(id)
  end

  def search_data
    attrs = attributes.dup
    relational = {
      product_variants_amount: product_variants.map(&:amount),
      product_variants_status: product_variants.map(&:status),
      product_variants_published: product_variants.map(&:published),
      product_variants_id: product_variants.map(&:id)
    }
    attrs.merge! relational
  end
end
