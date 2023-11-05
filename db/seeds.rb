# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Folder.create(name: "All")
Folder.create(name: "Work")

Step.create(
  content: [
    "Documenting your business. In Trainual, content is structured with an outline consiting of Subjects, Topic, and Steps.",
    "Welcome to the world of streamlined onboarding with Trainual LMS! Our comprehensive Learning Management System (LMS) is designed to make the onboarding process smoother, more efficient, and engaging for both your organization and your new team members.",
    "Day 1: Introduction to TrainualYour journey begins with an introduction to Trainual. Learn how to access the platform, navigate its user-friendly interface, and discover the wealth of resources at your fingertips. Our platform is designed to empower you to manage and optimize your onboarding process.",
    "Day 2: Role-Specific TrainingAt Trainual, we understand that every role within your organization is unique. On this day, your personalized learning path will kick in. You'll have access to role-specific training modules that are tailored to your job responsibilities, ensuring that you acquire the skills and knowledge you need to excel."
  ].join('. ')
)
