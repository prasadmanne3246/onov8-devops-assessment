const mongoose = require("mongoose");

// Connect to local MongoDB
const DB = "mongodb://127.0.0.1:27017/jeevandb";

mongoose.connect(DB, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(async () => {
    console.log("✅ MongoDB connected for seeding");

    // Sample student data
    const students = [
      { name: "Jeevan Prasad", age: 28, course: "DevOps" },
      { name: "Anjali Sharma", age: 25, course: "Cloud" },
      { name: "Ravi Kumar", age: 30, course: "Backend" }
    ];

    // Insert data into "students" collection
    const result = await mongoose.connection.db.collection("students").insertMany(students);
    console.log(`✅ Inserted ${result.insertedCount} students`);

    mongoose.connection.close();
  })
  .catch(err => console.log("❌ DB connection error:", err.message));
