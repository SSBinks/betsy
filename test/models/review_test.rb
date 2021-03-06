require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  test "Creating a new review will instantiate rating as nil" do
    r = Review.new
    assert_equal(nil, r.rating)
  end

  test "Cannot save a nil rating to the database" do
    no_rating = Review.new(description: "whatever", product_id: 123)
    assert_not no_rating.valid?
    assert_includes(no_rating.errors, :rating)
  end

  test "Can create reviews with ratings between 1 and 5" do
    assert reviews(:one_star).valid?
    assert reviews(:four_star).valid?
    assert reviews(:five_star).valid?
  end

  test "Can only create reviews with integer ratings" do
    float_rating = Review.new(rating: 3.2, description: "whatever", product_id: 123)
    assert_not float_rating.valid?
    assert_includes(float_rating.errors, :rating)

    string_rating = Review.new(rating: "excellent", description: "whatever", product_id: 123)
    assert_not string_rating.valid?
    assert_includes(string_rating.errors, :rating)
  end

  test "Cannot create reviews with ratings less than 1 or greater than 5" do
    too_low_rating = Review.new(rating: 0, description: "whatever", product_id: 123)
    assert_not too_low_rating.valid?
    assert_includes(too_low_rating.errors, :rating)

    too_high_rating = Review.new(rating: 6, description: "whatever", product_id: 123)
    assert_not too_high_rating.valid?
    assert_includes(too_high_rating.errors, :rating)
  end

  test "Review creation requires a description [string]" do
    assert reviews(:one_star).valid?

    no_description = Review.new(rating: 0, product_id: 123)
    assert_not no_description.valid?
    assert_includes(no_description.errors, :description)
  end

  test "Can only create reviews with descriptions 400 characters or less" do
    assert reviews(:character_400).valid?

    character_401 = Review.new(rating: 0, product_id: 123, description: "Here is a review of a book for sale. It is a great book, worth reading and possibly adding to your personal library. You will not be disappointed. Check this book out from your local library so you can form your own opinion and upvote it here. klsfjshrjdf lkajsf jej faiosejf esj oiasejf lsdjf ;oasjef ojsdfkl jasefj sodf lsdfj oisejf SDJf lKSDJFo iejw lKDSFJ l;SEF SIefj l;KSZDf sd eddjjrhdm fydowkf!")
    assert_not character_401.valid?
    assert_includes(character_401.errors, :description)
  end

  test "Review creation requires a product_id [integer]" do
    assert reviews(:one_star).valid?

    no_product_id = Review.new(rating: 0, description: "hello")
    assert_not no_product_id.valid?
    assert_includes(no_product_id.errors, :product_id)
  end

  test "Review belongs to a product" do
    review = reviews(:one_star)

    assert_respond_to review, :product
  end
end
