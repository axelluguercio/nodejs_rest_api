import jwt from 'jsonwebtoken';
import config from '../config';

// Custom function to generate JWT
export const generateToken = (user, pass) => {

    const secret = config.secret;

    try {
        const token = jwt.sign({ "username": user, "password": pass }, secret, { expiresIn: '6s' });
        return token;
    } catch (error) {
        console.log(error);
    }
}