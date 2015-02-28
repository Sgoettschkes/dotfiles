#!/usr/bin/env python
# -*- coding: utf-8 -*-

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
        "Choke X Chain",
        "Count on Pride",
        "Downset",
        "Earth Crisis",
        "Forget the Hate",
        "Fucked Up",
        "Fun People",
        "Fury of Five",
        "Fürsöna",
        "Hatebreed",
        "Have Heart",
        "Ignite",
        "Intensity",
        "Last Laugh",
        "Light your Anchor",
        "Look my Way",
        "Madball",
        "Nasty",
        "Nine",
        "Pro-Pain",
        "Racial Abuse",
        "Right Direction",
        "Risk it!",
        "Sense of Justice",
        "Shelter",
        "Sick of it All",
        "Submissives",
        "Suicidal Tendencies",
        "thesedays",
        "Throwdown",
        "Union 13",
        "xCROSSBEARERx",
        "Youth of Today",
        # Other
        "Alexisonfire",
        "Bring me the Horizon",
        "The Browning",
        "Captive Eyes",
        "Carnifex",
        "Comaspool",
        "Despised Icon",
        "Eighteen Visions",
        "Emmure",
        "Enter Shikari",
        "From Autumn to Ashes",
        "Helia",
        "I am Ghost",
        "In Flames",
        "Return the Queen",
        "Sonic Syndicate",
        "Suicide Silence",
        "The Used",
        "Thrice",
        "Thursday",
        "Vanna",
        "We Butter the Bread with Butter",
        "Whitechapel"
        ]

def main():
    for artist in artists:
        dir = "/home/sebastian/Music/Alben/" + artist
        if not os.path.isdir(dir):
            dir = "/home/sebastian/Music/Digital/" + artist
        subprocess.check_call(["rsync","--archive","--recursive","--verbose",dir,"/media/sebastian/E0D6-C698/Music"])

if __name__ == "__main__":
   main() 
