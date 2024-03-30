import requests
import os
import json
from bs4 import BeautifulSoup
import string
import xml.etree.ElementTree as ET

# Base URL for course data
base_url = "https://courses.illinois.edu/cisapp/explorer/schedule/2023/fall/"

# Parse the input XML data
tree = ET.parse('C:/Users/aplot/Documents/School/UIUC/CS 222 - Software Design Lab/group-project-team11/Course Data/allCS.xml')
root = tree.getroot()

# Create a list to store course information
all_courses = []

# Extract course information
courses = root.find("courses")

for course in courses.findall("course"):
    course_info = {}
    course_info["id"] = course.get("id")
    course_info["href"] = course.get("href")
    course_info["name"] = course.text

    # Send an HTTP GET request to the course link
    response = requests.get(base_url + course_info["href"])

    # Check if the request was successful (status code 200)
    if response.status_code == 200:
        # Parse the XML response for additional course details if needed
        # For example, you can use BeautifulSoup or xml.etree.ElementTree

        # Add the course details to the dictionary
        course_info["details"] = "Additional course details go here"

        # Append the course information to the list
        all_courses.append(course_info)
    else:
        print(f"Failed to retrieve data for {course_info['href']}, status code: {response.status_code}")

# Save all course data to a single JSON file
with open("all_courses.json", "w") as json_file:
    json.dump(all_courses, json_file, indent=2)

print("Saved all course data to all_courses.json")
