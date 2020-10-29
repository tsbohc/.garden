# How can I batch embed JPG thumbnails into MKV videos with a linux CLI other than ffmpeg?

19 | 1603723753.0

I need to batch embed thumbnails, I don't want to use ffmpeg because it outputs an entirely new video (which takes a super long time with videos that are hours long even with `-c copy`). I want to embed without having a new copy of the video. I tried mkvtoolnix (mkvpropedit), but I have issues with the following commands:

* `mkvpropedit "&lt;video&gt;" --add-attachment "cover.jpg"`
* `mkvpropedit "&lt;video&gt;" --attachment-mime-type "image/jpeg" --add-attachment "cover.jpg"`
* `mkvpropedit "&lt;video&gt;" --attachment-name "cover" --add-attachment "cover.jpg"`
* `mkvpropedit "&lt;video&gt;" --attachment-name "cover" --attachment-mime-type "image/jpeg" --add-attachment "cover.jpg"`

Is there any way to get it working with mkvpropedit, or perhaps with some other CLI?