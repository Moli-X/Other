/*
脚本作者litieyin
转载自https://raw.githubusercontent.com/litieyin/AD_VIP/main/Script/notability.js
*/

let obj = JSON.parse($response.body);
obj = {"data":{"processAppleReceipt":{"__typename":"SubscriptionResult","error":0,"subscription":{"__typename":"AppStoreSubscription","status":"active","originalPurchaseDate":"2021-11-09T03:14:18.000Z","originalTransactionId":"710000869822929","expirationDate":"2099-12-31T03:14:17.000Z","productId":"com.gingerlabs.Notability.premium_subscription","tier":"premium","refundedDate":null,"refundedReason":null,"user":null}}}};
$done({body: JSON.stringify(obj)});
