import { Router } from 'express';
import { methods as apiController } from '../controllers/api.controller';
import allowOnlyPost from '../middlewares/api.middleware';
import { requireToken as validator } from '../middlewares/api.requireToken';

const router = Router();;

// redirect to the main post method
router.get("/", (req, res) => {
    res.redirect("/DevOps");
    res.status(200);
});

// main post method, only POST allowed
router.use("/DevOps", allowOnlyPost);

// Authenthicate
router.post("/DevOps/token", apiController.sendToken);

router.post("/DevOps", validator, apiController.sendMessage);

export default router;