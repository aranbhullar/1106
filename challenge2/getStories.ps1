# Number of stories to fetch
$num_stories = 20

# Base URL for the Hacker News API
$base_url = "https://hacker-news.firebaseio.com/v0"

# Fetch the IDs of the top stories
$top_story_ids = (Invoke-RestMethod -Uri "$base_url/topstories.json") | Select-Object -First $num_stories

# Check if the top_story_ids is empty
if ($null -eq $top_story_ids -or $top_story_ids.Count -eq 0) {
    Write-Output "Failed to fetch top stories. Exiting."
    exit 1
}

# Loop through each story ID, extract title and URL
Write-Output "Top $num_stories Articles:"
$counter = 1
foreach ($story_id in $top_story_ids) {
    $story_url = "$base_url/item/$story_id.json"
    $story = Invoke-RestMethod -Uri $story_url
    $title = $story.title
    $url = $story.url
    Write-Output "$counter. $title - $url"
    $counter++
}
