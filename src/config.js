import { config } from 'dotenv';

config();

export default {
    host: process.env.HOST,
    key: process.env.API_KEY,
    secret: process.env.JWT_SECRET,
}