// Custom middleware to accept only POST requests
const allowOnlyPost = (req, res, next) => {
    if (req.method !== 'POST') {
        return res.status(200).send(`ERROR`)
    }
    next();
}

export default allowOnlyPost;