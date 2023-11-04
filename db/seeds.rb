# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


all = Folder.create(name: "All")
work = Folder.create(name: "Work")
personal = Folder.create(name: "Personal")

Audio.create(
  title: "How to use the app",
  folder_id: all.id,
  link: "https://trainual.com/manual/bringing-your-eos-accountability-chart-to-life-the-power-of-roles-responsibilities",
  src: "https://storage.googleapis.com/hackaton-trainual/bringing-your-eos-accountability-chart-to-life-the-power-of-roles-responsibilities.mp3"
)
Audio.create(
  title: "How to deploy",
  folder_id: work.id,
  link: "https://trainual.com/manual/bringing-your-eos-accountability-chart-to-life-the-power-of-roles-responsibilities",
  src: "https://storage.googleapis.com/hackaton-trainual/bringing-your-eos-accountability-chart-to-life-the-power-of-roles-responsibilities.mp3"
)
Audio.create(
  title: "How to play football",
  folder_id: personal.id,
  link: "https://trainual.com/manual/bringing-your-eos-accountability-chart-to-life-the-power-of-roles-responsibilities",
  src: "https://storage.googleapis.com/hackaton-trainual/bringing-your-eos-accountability-chart-to-life-the-power-of-roles-responsibilities.mp3"
)
