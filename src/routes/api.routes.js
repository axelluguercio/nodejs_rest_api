import { Router } from 'express';
import { methods as apiController } from '../controllers/api.controller';
import allowOnlyPost from '../middlewares/api.middleware';
import { requireToken as validator } from '../middlewares/api.requireToken';

const router = Router();
//const { allowOnlyPost } = require("../middlewares/api.requireToken");

router.get("/", (req, res) => {
    res.redirect("/DevOps");
    res.status(200);
});

router.use("/DevOps", allowOnlyPost);

// Authenthicate
router.post("/DevOps/token", apiController.sendToken);

router.post("/DevOps", validator, apiController.sendMessage);

export default router;