import config from '../config';
import { generateToken as generator } from "../utils/tokenManager";

// main post method
const sendMessage = (req, res) => {

    try {
        const api_key = req.get('x-parse-rest-api-key');
        const dest = req.body.to;
    
        if (api_key === undefined || api_key !== config.key) 
            res.status(401).send(`api key invalid`);

        if (dest === undefined || dest === null)
            res.status(400).send("A receiver is required, please provide a valid destination");
        else 
            res.json({ message: "Hello " + dest + " your message will be send" });

    } catch (error) {
        res.status(500);
        res.send(error.message);
    }
}

const sendToken = (req, res) => {

    try {

        const user = req.body.username;
        const pass = req.body.password;

        if (user === undefined || user === null && pass === undefined || pass === null)
            res.status(401).send(`must specify username and password`);
        else 
            res.send(generator(user, pass));

    } catch (error) {
        res.status(500);
        res.json(error.message);
    }
}

export const methods = {
    sendMessage,
    sendToken
}