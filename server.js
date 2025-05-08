var port = 3000;

const express = require("express");
const app = express();
app.set("view engine", "ejs");
const path = require("path");
const publicDirectory = path.join(__dirname, "./public");
app.use(express.static(publicDirectory));

app.get("/", (req, res) => {
  res.render("index");
});

app.get("/customers", (req, res) => {
  res.render("customers");
});

app.get("/matches", (req, res) => {
  res.render("matches");
});

app.get("/matchTickets", (req, res) => {
  res.render("matchTickets");
});

app.get("/orders", (req, res) => {
  res.render("orders");
});

app.get("/seats", (req, res) => {
  res.render("seats");
});

app.listen(port, () => {
  console.log("Server started on Port", port);
});
