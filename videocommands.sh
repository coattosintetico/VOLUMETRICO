# Generate a video from a sequence of images
ffmpeg -framerate 24 -i savedFrames/frame%05d.jpg -c:v libx264 -pix_fmt yuv420p output.mp4

# Change framerate of the video with reencoding
ffmpeg -i input_video.mp4 -vf "fps=24" -c:v libx264 -preset medium -crf 23 -c:a copy output_video.mp4

# Extract the framerates of a video as .jpg
ffmpeg -i input_video.mp4 path_to_folder/frame%05d.jpg

# Generate a video from a sequence of images and include an audio file. Cut the video when the images end
ffmpeg -framerate 24 -i frame%05d.jpg -i audiofile.opus -c:v libx264 -c:a aac -shortest output.mp4

# Transform an opus file into a mp3 file
ffmpeg -i input.opus -acodec libmp3lame -q:a 2 output.mp3

# Cut a video to 59 seconds
ffmpeg -i input_video.mp4 -ss 00:00:00 -t 59 -c:v copy -c:a copy output_video.mp4
