# For analyzing the colocalization ratio of two interest channels
This analysis was performed using Cellpose Python package, Fiji and Matlab software.
Briefly, Cellpose was used to identify the cell candidates; to reduce false positive in low signal-noise-ratio images, foreground cell masks were generated using Fiji thresholding; finally, a Matlab script was used to determine the masks of individual cells by combining the cell candidates and foreground cell masks. 
