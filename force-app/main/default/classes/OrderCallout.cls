public with sharing class OrderCallout {
    @InvocableMethod(label='Send orders to API' description='Sends given orders to mock API.' category='Order')
    public static HttpResponse makeCallout(List<Id> orderIds) {
        // if (orderIds.size() == 0) {
            // TODO: throw error
        // }

        // if (orderIds.size() > 30) {
            // TODO: throw limitation error
        }

        // query required fields of order items to send to API
        List<Order> orders = [SELECT Id, OrderNumber, Account.PersonEmail FROM Order WHERE Id IN :orderIds];

        // instantiate list of order request objects to send to API
        List<OrderRequestObject> orderRequestObjects = new List<OrderRequestObject>();

        // transform orders to order request objects to fit API
        for (Order ord : orders) {
            // instatiate an order request object from retrieved Order data
            OrderRequestObject requestObject = new OrderRequestObject();
            requestObject.sfId = ord.Id;
            requestObject.orderNumber = ord.OrderNumber;
            requestObject.customerEmail = ord.Account.PersonEmail;

            // add created object to list, which will be sent to API
            orderRequestObjects.add(requestObject);
        }

        // prepare callout to API
        HttpRequest request = new HttpRequest();
        // set API endpoint
        request.setEndpoint('https://salesforce-coding-challenge.herokuapp.com/orders');
        // set type of http request to POST
        request.setMethod('POST');
        // set content type of request to json
        request.setHeader('Content-Type', 'application/json');
        // create json string from order request objects
        String serializedOrderRequestObjects = JSON.serialize(orderRequestObjects);
        // set json string as body
        request.setBody(serializedOrderRequestObjects);

        // send the API request
        HttpResponse response = new Http().send(request);

        return response;
    }

    private class OrderRequestObject {
        private String sfId { get; set; }
        private String orderNumber { get; set; }
        private String customerEmail { get; set; }
    }
}
