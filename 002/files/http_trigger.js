exports.helloGET = function helloGET (req, res) {
    res.send(`Hello ${req.body.name || 'World'}!`);
};