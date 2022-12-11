global class OrderCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // create a response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"recieved":"true"}');
        response.setStatusCode(200);
        return response;
    }
}