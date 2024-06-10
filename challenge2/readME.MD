# Fetch Top Hacker News Articles
This PowerShell script fetches the top 20 stories from Hacker News using the Hacker News API and displays their titles and URLs.

## Prerequisites
PowerShell (Windows PowerShell or PowerShell Core)
Internet connection
## Parameters
$num_stories: Number of top stories to fetch (default is 20).
$base_url: Base URL for the Hacker News API.
## Script Details
The script performs the following steps:

Fetches the IDs of the top stories from the Hacker News API.
Checks if the top stories were fetched successfully.
Loops through each story ID and extracts the title and URL.
Outputs the titles and URLs of the top stories.
## Usage
### Save the Script:
Save the script to a file, for example, FetchTopHackerNews.ps1.

### Run the Script:
Open a PowerShell terminal and navigate to the directory where the script is saved. Run the script using the following command:

powershell
.\FetchTopHackerNews.ps1
### Output:
The script will display the titles and URLs of the top 20 Hacker News articles.

## PowerShell Script
Save the following PowerShell script as FetchTopHackerNews.ps1:

powershell
### Number of stories to fetch
```
$num_stories = 20
```
### Base URL for the Hacker News API
```
$base_url = "https://hacker-news.firebaseio.com/v0"
```
### Fetch the IDs of the top stories
```
$top_story_ids = (Invoke-RestMethod -Uri "$base_url/topstories.json") | Select-Object -First $num_stories
```
### Check if the top_story_ids is empty
```
if ($null -eq $top_story_ids -or $top_story_ids.Count -eq 0) {
    Write-Output "Failed to fetch top stories. Exiting."
    exit 1
}
```
### Loop through each story ID, extract title and URL
```
Write-Output "Top 20 Articles:"
$counter = 1
foreach ($story_id in $top_story_ids) {
    $story_url = "$base_url/item/$story_id.json"
    $story = Invoke-RestMethod -Uri $story_url
    $title = $story.title
    $url = $story.url
    Write-Output "$counter. $title - $url"
    $counter++
}
```
#### Notes
Ensure you have an active internet connection to fetch data from the Hacker News API.
You can modify the $num_stories variable to fetch a different number of top stories if needed.