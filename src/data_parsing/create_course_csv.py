import requests
import os
import json
# from bs4 import BeautifulSoup
import string
import xml.etree.ElementTree as ET
import csv

# Base URL for course data
# base_url = "https://courses.illinois.edu/cisapp/explorer/schedule/2023/spring/"

# Parse the input XML data
tree = ET.parse('data_parsing/XML_docs/spring_2024.xml')
root = tree.getroot()

# Create a list to store departments
all_departments = []

# Extract course information
all_departments = root.find("subjects")

# year_semester = year, semester
# dept_info_list = abbreviation, deptname
# course_info_list = courseNum, courseName, creditHours, description, genEdAttr
# section_info_list = crn, sectionName, sectionType, instructors

# general course = course_info_list + dept_info_list
# section attributes = section_info_list + dept_info_list + year_semester

year_semester = []
year_semester.append(root.find("parents").find("calendarYear").text)
year_semester.append(root.find("label").text)

general_course = open('data_parsing/general_course.csv', 'w', newline='')
section_attributes = open('data_parsing/section_attributes.csv', 'w', newline='')


writer_general = csv.writer(general_course)
writer_section = csv.writer(section_attributes)


for dept in all_departments.findall("subject"):
    """
    dept_info = {}
    dept_info["abbreviation"] = dept.get("id")
    dept_info["href"] = dept.get("href")
    dept_info["name"] = dept.text
    """
    dept_info = []
    dept_info.append(dept.get("id"))
    dept_info.append(dept.text)
    # Send an HTTP GET request to the dept link
    response = requests.get(dept.get("href"))

    # Check if the request was successful
    if response.status_code == 200:
        dept_root = ET.fromstring(response.text)

        # Extract course information
        courses = dept_root.find("courses")

        for course in courses.findall("course"):
            """
            course_info = {}
            course_info["id"] = course.get("id")
            course_info["href"] = course.get("href")
            course_info["name"] = course.text
            """
            course_info = []
            course_info.append(course.get("id"))
            course_info.append(course.text)

            # not sure if this needs to be a separate response var or not
            response = requests.get(course.get("href"))

            if response.status_code == 200:
                course_root = ET.fromstring(response.text)

                #course_info["creditHours"] = course.find("creditHours").text
                #course_info["description"] = course.find("description").text
                course_info.append(course_root.find("creditHours").text)
                course_info.append(course_root.find("description").text)
                try:
                    # not all courses have 'sectionDegreeAttributes'
                    #course_info["gen_ed_attr"] = course.find("sectionDegreeAttributes").text
                    course_info.append(course_root.find("sectionDegreeAttributes").text)
                except:
                    #course_info["gen_ed_attr"] = ""
                    course_info.append("")

                # make general course csv line here
                writer_general.writerow(course_info + dept_info)
                
                sections = course_root.find("sections")

                for section in sections.findall("section"):
                    """
                    section_info = {}
                    section_info["crn"] = section.get("id")
                    section_info["section_name"] = section.text
                    """
                    section_info = []
                    section_info.append(section.get("id"))
                    section_info.append(section.text)

                    response = requests.get(section.get("href"))

                    if response.status_code == 200:
                        section_root = ET.fromstring(response.text)

                        meetings = section_root.find("meetings")

                        for meeting in meetings.findall("meeting"):
                            #section_info["type"] = meeting.find("type").text
                            section_info.append(meeting.find("type").text)

                            instructors = meeting.find("instructors")
                            
                            instructors_string = ""
                            for instructor in instructors.findall("instructor"):
                                instructors_string += (instructor.text + ";")
                            
                            #section_info["instructors"] = instructors_string
                            section_info.append(instructors_string)

                            # make section CSV row
                            writer_section.writerow(section_info + dept_info + year_semester)

                    else: 
                        print(f"Failed to retrieve data for {section.get("href")}, status code: {response.status_code}")

            else:
                print(f"Failed to retrieve data for {course.get("href")}, status code: {response.status_code}")
    else:
        print(f"Failed to retrieve data for {dept.get("href")}, status code: {response.status_code}")

# Save all course data to a single JSON file
# with open("all_courses.json", "w") as json_file:
   # json.dump(all_courses, json_file, indent=2)

print("Saved all course data to all_courses.json")