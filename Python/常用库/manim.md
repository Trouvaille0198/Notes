# 一、执行文件

`manimgl yourfile.py [className] [-params]`

- `-w` to write the scene to a file

- `-o` to write the scene to a file and open the result

- `-s` to skip to the end and just show the final frame.
    - `-so` will save the final frame to an image and show it
    
- `-n <number>` to skip ahead to the `n`'th animation of a scene.

- `-f` to make the playback window fullscreen

| flag                                                    | abbr | function                                                     |
| ------------------------------------------------------- | ---- | ------------------------------------------------------------ |
| `--help`                                                | `-h` | Show the help message and exit                               |
| `--write_file`                                          | `-w` | **Render the scene as a movie file**                         |
| `--skip_animations`                                     | `-s` | Skip to the last frame                                       |
| `--low_quality`                                         | `-l` | Render at a low quality (for faster rendering)               |
| `--medium_quality`                                      | `-m` | Render at a medium quality                                   |
| `--hd`                                                  |      | Render at a 1080p quality                                    |
| `--uhd`                                                 |      | Render at a 4k quality                                       |
| `--full_screen`                                         | `-f` | **Show window in full screen**                               |
| `--save_pngs`                                           | `-g` | Save each frame as a png                                     |
| `--save_as_gif`                                         | `-i` | Save the video as gif                                        |
| `--transparent`                                         | `-t` | Render to a movie file with an alpha channel                 |
| `--quiet`                                               | `-q` |                                                              |
| `--write_all`                                           | `-a` | Write all the scenes from a file                             |
| `--open`                                                | `-o` | Automatically open the saved file once its done              |
| `--finder`                                              |      | Show the output file in finder                               |
| `--config`                                              |      | Guide for automatic configuration                            |
| `--file_name FILE_NAME`                                 |      | Name for the movie or image file                             |
| `--start_at_animation_number START_AT_ANIMATION_NUMBER` | `-n` | Start rendering not from the first animation, but from another, specified by its index. If you passin two comma separated values, e.g. “3,6”, it will end the rendering at the second value. |
| `--resolution RESOLUTION`                               | `-r` | Resolution, passed as “WxH”, e.g. “1920x1080”                |
| `--frame_rate FRAME_RATE`                               |      | Frame rate, as an integer                                    |
| `--color COLOR`                                         | `-c` | Background color                                             |
| `--leave_progress_bars`                                 |      | Leave progress bars displayed in terminal                    |
| `--video_dir VIDEO_DIR`                                 |      | directory to write video                                     |

# 二、Mobject

