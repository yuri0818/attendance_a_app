# coding: utf-8

User.create!(name: "Sample User",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password", 
             admin: true)
             
User.create!(name: "上長A",
             email: "sample1@email.com",
             password: "password",
             password_confirmation: "password",
             superior: true)
         
User.create!(name: "上長B",
             email: "sample2@email.com",
             password: "password",
             password_confirmation: "password", 
             superior: true)
                        