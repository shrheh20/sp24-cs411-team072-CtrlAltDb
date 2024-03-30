import requests
import os
from bs4 import BeautifulSoup
import string
import xml.etree.ElementTree as ET
import xmltodict

# Base URL for course data
base_url = "https://courses.illinois.edu/cisapp/explorer/schedule/2023/fall/"

# Example link
example_link = "CS/421.xml"

# Parse the input XML data
tree = ET.parse('C:/Users/aplot/Documents/School/UIUC/CS 222 - Software Design Lab/group-project-team11/Course Data/allCS.xml')
root = tree.getroot()

# Create a dictionary to store course information
course_info = {}

# Extract information from the XML
course_info["subject"] = root.find("label").text
course_info["collegeCode"] = root.find("collegeCode").text
course_info["departmentCode"] = root.find("departmentCode").text
course_info["unitName"] = root.find("unitName").text
course_info["contactName"] = root.find("contactName").text
course_info["contactTitle"] = root.find("contactTitle").text
course_info["addressLine1"] = root.find("addressLine1").text
course_info["addressLine2"] = root.find("addressLine2").text
course_info["phoneNumber"] = root.find("phoneNumber").text
course_info["webSiteURL"] = root.find("webSiteURL").text

# Extract course information
courses = root.find("courses")
course_info["course_list"] = []

for course in courses.findall("course"):
    course_data = {}
    course_data["id"] = course.get("id")
    course_data["href"] = course.get("href")
    course_data["name"] = course.text
    course_info["course_list"].append(course_data)

# Print the extracted course information
for key, value in course_info.items():
    if key == "course_list":
        print("Courses:")
        for course in value:
            print(f"- ID: {course['id']}")
            print(f"  Name: {course['name']}")
            print(f"  Href: {course['href']}")

            example_link = "CS/" + course['id'] + ".xml"
            # Send an HTTP GET request to the example link
            response = requests.get(base_url + example_link)

            # Check if the request was successful (status code 200)
            if response.status_code == 200:
            
               
                # Parse XML to a Python dictionary
                parsed_dict = xmltodict.parse(response)

                # Convert the dictionary to JSON
                json_data = json.dumps(parsed_dict, indent=2)
                
                print(json_data)
                
                sleep(5)
            
                # Extract the course number from the example link
                course_number = os.path.splitext(example_link)[0]
                course_number = course_number.replace("/", "")

                # Create a directory to store the XML files (if it doesn't exist)
                #if not os.path.exists("course_data"):
                #    os.makedirs("course_data")

                # Define the file path to save the XML data
                file_path = os.path.join("Course Data", f"{course_number}.xml")

                # Save the returned XML data to a file
                with open(file_path, "wb") as xml_file:
                    xml_file.write(response.content)

                print(f"Saved data for {course_number} to {file_path}")
            else:
                print(f"Failed to retrieve data for {example_link}, status code: {response.status_code}")
    else:
        print(f"{key}: {value}")








