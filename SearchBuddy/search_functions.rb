
def get_job_title(user_job_title)
  if user_job_title.length == 2 ||user_job_title.length == 3
    job_title = user_job_title.upcase
  else
  job_title = user_job_title.downcase
  end
  return job_title
end

def get_job_spec(user_job_spec)
 job_spec = []
 user_job_spec = user_job_spec.to_s
 user_job_spec = user_job_spec.gsub(/[,.]/,"")
 job_spec = user_job_spec.split(" ")
 return job_spec
end

def rank_words(user_job_spec, searches)
  job_spec = []
  user_job_spec = user_job_spec.to_s
  user_job_spec = user_job_spec.gsub(/[',.]/,"")
  job_spec = user_job_spec.split(" ")

  frequencies = Hash.new(0)
  job_spec.each { |word| frequencies[word] += 1 }
  frequencies = frequencies.sort_by {|a, b| b }
  frequencies.reverse!
  # frequencies = frequencies.each { |word, frequency| puts word + " " + frequency.to_s }
  return frequencies
end

def match_job_title(job_title, searches)
 matched_job_title = []
  for search in searches
    if search[:title].include? job_title
      matched_job_title << search[:title][0]
    end
  end
 return matched_job_title[0]
end

def match_key_words(job_title, job_spec, searches)
 key_words = []
 all_key_words = Hash.new
 matched_job_title = match_job_title(job_title, searches)
 words_list = get_job_spec(job_spec)
 for search in searches
   if search[:title][0] == matched_job_title
     all_key_words = all_key_words.merge(search[:key_words])
     all_key_words = all_key_words.values.to_a
     all_key_words = all_key_words.flatten
     for word in words_list
        # return all_key_words
       for key_word in all_key_words
         if key_word.downcase == word.downcase
           key_words << word
         end
       end
     end
   end
 end
 return key_words.sort
end

def match_job_title2(job_title, searches)
 matched_job_title = []
  for search in searches
    if search[:title].include? job_title
      matched_job_title << search[:title][0]
    end
  end
 return matched_job_title[0]
end

def rank_words2(key_words, searches)
  frequencies = Hash.new(0)
  key_words.each { |word| frequencies[word] += 1 }
  frequencies = frequencies.sort_by {|a, b| b }
  frequencies.reverse!
  return frequencies
end

def job_key_words(job_title, searches)
  matched_job_title = match_job_title(job_title, searches)
  all_key_words = Hash.new
  for search in searches
    if search[:title][0] == matched_job_title
      all_key_words = all_key_words.merge(search[:key_words])
      all_key_words = all_key_words.values.to_a
      all_key_words = all_key_words.sort
    end
  end
  return all_key_words.sort
end

def write_search(job_title, job_spec, searches)
  written_search = []
  written_search_collect = []
  written_search_collect2 =[]
  written_search_collect3 =[]
  matched_job_title = match_job_title(job_title, searches)
  needed_key_words = match_key_words(job_title, job_spec, searches)
  all_key_words = job_key_words(job_title, searches)
  for key_words in all_key_words
    for needed_word in needed_key_words
     if key_words.include? needed_word
       written_search << key_words
       written_search = written_search.uniq
     end
    end
  end
  written_search = written_search
  for search in written_search
    if search.length > 1
      written_search_collect << [search.join(" OR ")]
      written_search_collect = written_search_collect.flatten
      written_search_collect = [written_search_collect.insert(0,"(")]
      written_search_collect = [written_search_collect.insert(-1,")")]
      written_search_collect = [written_search_collect.join("")]
      written_search_collect3.push(written_search_collect)
    end
    if search.length < 2
      written_search_collect2 << search
      written_search_collect2 = written_search_collect2.flatten
    end
  end
  written_search_collect3 << written_search_collect2
  written_search_collect3 = written_search_collect3.flatten
  written_search_collect3 = [written_search_collect3.join(" AND ")]
  return written_search_collect3[0]
end
