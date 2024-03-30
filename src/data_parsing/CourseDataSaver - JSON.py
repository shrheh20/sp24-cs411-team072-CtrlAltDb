import requests
import os
import json
import xml.etree.ElementTree as ET
from bs4 import BeautifulSoup

# Base URL for course data
base_url = "https://courses.illinois.edu/cisapp/explorer/schedule/2023/fall/CS/421.xml"

# Example link
example_link = "CS/421.xml"

# Parse the input XML data
tree = ET.parse('C:/Users/aplot/Documents/School/UIUC/CS 222 - Software Design Lab/group-project-team11/Course Data/allCS.xml')
root = tree.getroot()

# Create a dictionary to store all course data
all_course_data = {}

# Extract information from the XML
all_course_data["subject"] = root.find("label").text
all_course_data["collegeCode"] = root.find("collegeCode").text
all_course_data["departmentCode"] = root.find("departmentCode").text
all_course_data["unitName"] = root.find("unitName").text
all_course_data["contactName"] = root.find("contactName").text
all_course_data["contactTitle"] = root.find("contactTitle").text
all_course_data["addressLine1"] = root.find("addressLine1").text
all_course_data["addressLine2"] = root.find("addressLine2").text
all_course_data["phoneNumber"] = root.find("phoneNumber").text
all_course_data["webSiteURL"] = root.find("webSiteURL").text

# Extract course information
all_course_data["courses"] = []

for course in root.find("courses").findall("course"):
    course_data = {}
    course_data["id"] = course.get("id")
    course_data["href"] = course.get("href")
    course_data["name"] = course.text

    # Send an HTTP GET request to the example link
    response = requests.get(base_url + course_data["href"])

    # Check if the request was successful (status code 200)
    if response.status_code == 200:
        # Extract additional course details from the XML response
        course_detail_tree = ET.fromstring(response.content)
        course_data["details"] = {
            "title": course_detail_tree.find("label").text,
            "description": course_detail_tree.find("description").text
            # Add more details as needed
        }

        all_course_data["courses"].append(course_data)
        print(f"Retrieved data for {course_data['id']} - {course_data['name']}")
    else:
        print(f"Failed to retrieve data for {course_data['id']} - {course_data['name']}, status code: {response.status_code}")

# Save all course data to a JSON file
json_file_path = "all_course_data.json"
with open(json_file_path, "w") as json_file:
    json.dump(all_course_data, json_file, indent=2)

print(f"Saved all course data to {json_file_path}")
