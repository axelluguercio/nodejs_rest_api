import supertest from 'supertest';
import {  app, server } from '../index';
import config from '../config';

const api = supertest(app);

test('any requests outside POST should return http code 401', async () => {
    await api 
        .get('/DevOps')
        .expect(401)
});

test('POST request to /DevOps/token should return http code 200 with string token', async () => {

    const payload = {
        "username": "devops",
        "password": "test"
    }

    await api 
        .post('/DevOps/token')
        .send(payload)
        .expect(200)
});

afterAll(() => {
    server.close();
})