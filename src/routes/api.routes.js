import { Router } from 'express';
import { methods as apiController } from '../controllers/api.controller';
import { requireToken as validator } from '../middlewares/api.requireToken';

const router = Router();

// Authenthicate
router.post("/token", apiController.sendToken);

router.post("/", validator, apiController.sendMessage);

export default router;