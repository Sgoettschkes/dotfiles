#!/usr/bin/env python

import os
import subprocess

artists = [
        # Hardcore Punk
        "59 Times the Pain",
        "Bane",
        "Barcode",
        "Biohazard",
        "Blood for Betrayal",
        "Bloodshed Remains",
        "Born from Pain",
        "Boysetsfire",
        "Cancer Bats",
        "Cast Iron Hike",
        "Choke X Chain"
        ]

def main():
    for artist in artists:
        dir = "/home/sebastian/Music/Alben/" + artist
        if not os.path.isdir(dir):
            dir = "/home/sebastian/Music/Digital/" + artist
        subprocess.check_call(["rsync","--archive","--recursive","--verbose",dir,"/media/sebastian/E0D6-C698/Music"])

if __name__ == "__main__":
   main() 
