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

// Routes
app.use("/", routes);

export default app;