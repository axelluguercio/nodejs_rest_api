import express from "express";
import morgan from "morgan";
import bodyParser from "body-parser";

// Route
import routes from "./routes/api.routes";

const app=express();

// Settings
app.set("port", 4000);


// Middlewares
app.use(morgan("dev"));
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Custom middleware definition
const { allowOnlyPost } = require("./middlewares/api.middleware").default;

// Routes
app.use("/DevOps", allowOnlyPost, routes);

export default app;