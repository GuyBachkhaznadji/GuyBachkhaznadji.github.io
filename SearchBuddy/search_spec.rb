require_relative('./search_functions')
require_relative('./search_data')
require('minitest/autorun')

class SearchTest < MiniTest::Test

  def setup
    @searches = SEARCHES
  end

  def test_get_job_title1
    job_title = get_job_title("Project Manager")
    assert_equal("project manager", job_title)
  end

  def test_get_job_title2
    job_title = get_job_title("PM")
    assert_equal("PM", job_title)
  end

  def test_get_job_title3
    job_title = get_job_title("PMO")
    assert_equal("PMO", job_title)
  end

  def test_get_job_spec
    job_spec = get_job_spec("I am a job, spec")
    assert_equal(["I", "am", "a", "job", "spec"], job_spec)
  end

  def test_match_job_title
    matched_job_title = match_job_title("QS", @searches)
    assert_equal("Quantity Surveyor", matched_job_title)
  end

  def test_rank_words
    ranked_words = rank_words("I want Prince2 and NHS and some more NHS", @searches)
    assert_equal([["and", 2], ["NHS", 2], ["more", 1], ["some", 1], ["Prince2", 1], ["want", 1], ["I", 1]], ranked_words)
  end

  def test_match_key_words
    matched_key_words = match_key_words("Project Manager","I am an NHS, Prince2 job spec for the NHS", @searches)
    assert_equal(["NHS", "NHS", "Prince2"], matched_key_words)
  end

  def test_job_key_words
    ranked_words = job_key_words("PM", @searches)
    assert_equal([["NHS"], ["Prince2", "\"Prince 2\""], ["Scrum"]], ranked_words)
  end

  def test_rank_words2
    ranked_words = rank_words2(["NHS", "NHS", "Prince2"], @searches)
    assert_equal([["NHS", 2], ["Prince2", 1]], ranked_words)
  end


  def test_write_search
    written_search = write_search("PM","I am an NHS, Prince2 job spec for the NHS", @searches)
    assert_equal("(Prince2 OR \"Prince 2\") AND NHS", written_search)
  end

end
