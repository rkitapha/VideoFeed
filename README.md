# VideoFeed
**Overall Architecture Approach**
- MVVM
    - I have separated the video player, video feed, and text fields into three separate views
    - One view model for the video feed that handles getting the video data from the api
    - A video loader that handles all the video prefetching, video player storage, and cleaning up all the unused video players
    - There is one Video model that stores the video url with a UUID and a Video Response model that handles the json for getting the video urls from the api

**Memory Management**
  - Firstly, none of the videos or video url are stored locally, they only live within the view. The videos from the url are preloaded only when needed. If I were to store the videos locally or cached them, the memory would grow exponentially espeically with alot of big video files
  - I have preloaded the videos and stored them as AVPlayers in a players dictionary so that you can access previously loaded players when you swipe up and down in the video feed
  - I use LazyVStack to prevent unnecessary memory usage and slow rendering of the videoes, since we could have a large list of videos. As well as to try to keep the scrolling smooth

**Strategy for Smooth Transitions**
  - Using tiktok as an example, I believe that the smoothest transition that would give a similar feel to it would be using a Scroll view with a paging behavior
  - I also embedded the scroll view inside a scroll view reader, so that I can use the scrollproxy from it and allow the user to be able to go back to the first video when the user scrolls to the bottom of the feed or to the last video when the user swipes up from the first video
  - This paired along with the LazyVStack and preloading the next two videos in the feed allowed me to have a smooth transition between videos
  - One issue I do have is that there is a slight pause and transition to the first video from the last video and I cant really replicate the paging scrolling transition like I do for the other videos

**Key design decisions and trade-offs**
- Not storing the videos or video urls locally with something like Core Data or saving the videos to the cache. While this does save memory, users wouldnt be able to play the videos if they have no network connectivity
- Using a scroll view for the paging effect and embedding the LazyVstack inside of it. I could have instead added a gesture to the LazyVStack and not have the scroll view at all. I would have more control over the user scrolling and gesture velocity but I wouldnt be able to preciously mimic the paging effect and it would require a lot more code and complexity
- Instead of adding the same existing the videos to the video array in the list for the infinite scrolling, I chose to scroll to the first video. This does save a lot of memory for the array but in exchange, the transitioning from the last video to the first video is not the same as the other video transitions
- Preloading the next two videos can sometimes take a while so you are prevented from scrolling to the next video for a few seconds
 
