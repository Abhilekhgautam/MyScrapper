
# Scarp the stackoverflow's site for all julia question.

using Cascadia
using HTTP
using Gumbo

# Algorithm:
# 1. Scarp the first page
# 2. Find the link to next page
# 3. Scarp the next page
# 4. Repeat 2 & 3 until no next page is found

const baseURL = "https://stackoverflow.com"
function count_julia_q()
     html_response = parsehtml(String(HTTP.get("$baseURL/questions/tagged/julia-lang?tab=newest&pagesize=50")))

     selector_one = sel".s-post-summary"
     selector_two = sel"[rel=\"next\"]"
     count = 0

     while true
	question_summary = eachmatch(selector_one, html_response.root)
	count = count + length(question_summary)
	next_element = eachmatch(selector_two, html_response.root)

	if length(next_element) > 0 
		next = getattr(next_element[1], "href")
		html_response = parsehtml(String(HTTP.get("$baseURL$next").body))
	else
          break
	end
     end
     println("Total number of Julia Question $count")
end

@time count_julia_q()
