import jwt from 'jsonwebtoken';
import config from '../config';

export const requireToken = (req, res, next) => {

    try {

        const token = req.get('x-jwt-kwy');
        
        if (!token) 
            throw new Error('No token provided');
        
        const decoded = jwt.verify(token, config.secret);

        next();

    } catch (error) {

        return res.status(401).json({ error: error.message});
    }
}