const express = require("express");
const mongoose = require("mongoose");
const app = express();

// --- Environment Variables ---
const PORT = process.env.PORT || 3000;
const DB = process.env.MONGO_URL || "mongodb://mongo:27017/jeevandb"; // ✅ ECS: "mongo" = container name

// --- Middleware ---
app.use(express.json());

// --- Connect to MongoDB ---
mongoose.connect(DB, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(async () => {
    console.log("✅ MongoDB connected to jeevandb");

    const db = mongoose.connection.db;

    // --- Students Collection ---
    const studentsCol = db.collection("students");
    const studentCount = await studentsCol.countDocuments();
    if (studentCount === 0) {
      const students = [
        { name: "Jeevan Prasad", age: 28 },
        { name: "Anjali Sharma", age: 25 },
        { name: "Ravi Kumar", age: 30 }
      ];
      await studentsCol.insertMany(students);
      console.log(`✅ Inserted ${students.length} students`);
    }

    // --- Courses Collection ---
    const coursesCol = db.collection("courses");
    const courseCount = await coursesCol.countDocuments();
    if (courseCount === 0) {
      const courses = [
        { title: "DevOps Fundamentals", duration: "3 months" },
        { title: "Cloud Engineering", duration: "4 months" },
        { title: "Backend Development", duration: "5 months" }
      ];
      await coursesCol.insertMany(courses);
      console.log(`✅ Inserted ${courses.length} courses`);
    }

    // --- Enrollments Collection ---
    const enrollmentsCol = db.collection("enrollments");
    const enrollmentCount = await enrollmentsCol.countDocuments();
    if (enrollmentCount === 0) {
      const students = await studentsCol.find().toArray();
      const courses = await coursesCol.find().toArray();
      const enrollments = [
        { student: students[0]._id, course: courses[0]._id },
        { student: students[1]._id, course: courses[1]._id },
        { student: students[2]._id, course: courses[2]._id }
      ];
      await enrollmentsCol.insertMany(enrollments);
      console.log(`✅ Inserted ${enrollments.length} enrollments`);
    }

  })
  .catch(err => console.log("❌ DB connection error:", err.message));

// --- Routes ---

app.get("/", (req, res) => {
  res.send("🚀 ONOV8 DevOps Test App running successfully on ECS!");
});

app.get("/students", async (req, res) => {
  const students = await mongoose.connection.db.collection("students").find().toArray();
  res.json(students);
});

app.get("/courses", async (req, res) => {
  const courses = await mongoose.connection.db.collection("courses").find().toArray();
  res.json(courses);
});

app.get("/enrollments", async (req, res) => {
  const db = mongoose.connection.db;
  const enrollments = await db.collection("enrollments").find().toArray();
  const students = await db.collection("students").find().toArray();
  const courses = await db.collection("courses").find().toArray();

  const populated = enrollments.map(e => ({
    student: students.find(s => s._id.equals(e.student))?.name,
    course: courses.find(c => c._id.equals(e.course))?.title
  }));

  res.json(populated);
});

// ✅ Listen on 0.0.0.0 for ECS public access
app.listen(PORT, "0.0.0.0", () =>
  console.log(`✅ Server running on 0.0.0.0:${PORT} (ECS-ready)`)
);
