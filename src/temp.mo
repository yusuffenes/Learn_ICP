import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
actor 
{
  public type Donor = {
      name: Text;
      surname: Text;
      age: Nat;
      amountDonation: Nat;
      currency: Text;
      message: ?Text;
  };
  public type Recipient = 
  {
    name:Text;
    surname:Text;
    age:Nat;
    amountRequired:Nat;
    currency:Text;
    message: ?Text;
  };
  public type Donation = {
    donorName: Text;
    amount: Nat;
  };
  public type Request = {
    recipientName: Text;
    amount: Nat;
  };
  var donationId: Nat = 0;
  var donarId: Nat = 0;
  var donors: HashMap.HashMap<Text, Donor> = HashMap.HashMap<Text, Donor>(10, Text.equal, Text.hash);
  var safeBox: HashMap.HashMap<Text, Donation> = HashMap.HashMap<Text, Donation>(10, Text.equal, Text.hash);
  var requiredQuantity:HashMap.HashMap<Text, Nat> = HashMap.HashMap<Text, Nat>(10, Text.equal, Text.hash);
  var recipients: HashMap.HashMap<Text, Recipient> = HashMap.HashMap<Text, Recipient>(10, Text.equal, Text.hash);
  var requestId: Nat = 0;
  var recipientsId: Nat = 0;

  public func addDonorData(name: Text, surname: Text, age: Nat, amountDonation: Nat, currency: Text, message: ?Text): async () {
    let donor: Donor = {
        name = name;
        surname = surname;
        age = age;
        amountDonation = amountDonation;
        currency = currency;
        message = message;
    };
    donors.put(name, donor);
    donarId += 1;
    let donation: Donation = {
        donorName = name;
        amount = amountDonation;
    };

    safeBox.put(Nat.toText(donationId), donation);
    donationId += 1;
  };
  
  
  public func addRecipientData(name: Text,surname:Text,age:Nat,amountRequired:Nat,currency:Text,message:?Text): async () {
    let recipient:Recipient = {
      name = name;
      surname = surname;
      age = age;
      amountRequired = amountRequired;
      currency = currency;
      message = message;
    };
    recipients.put(name, recipient);
    recipientsId += 1;
    let request:Request = {
      recipientName = name;
      amount = amountRequired;
    };
    requiredQuantity.put(Nat.toText(requestId), amountRequired);
    requestId += 1;
    
  };
  public query func getTotalDonations(): async Nat {
    var total: Nat = 0;
    for ((_, donation) in safeBox.entries()) {
        total += donation.amount;
    };
    return total;
  };
  public query func getDonorData(name: Text): async ?Donor {
    return donors.get(name);
  };

  public func getRecipientData(name: Text): async ?Recipient {
    return recipients.get(name);
  };

  
public func processRequests(): async () {
  let totalDonations = await getTotalDonations();
  var processedRequests: [Text] = [];
  
  for ((name, recipient) in recipients.entries()) {
    let maybeAmountRequired = requiredQuantity.get(Nat.toText(recipientsId));
    switch (maybeAmountRequired) {
      case (null){};
      case (?amountRequired) {
        if (totalDonations >= amountRequired) {
          totalDonations -= amountRequired;
          recipients.remove(name);
          
        }
      }
    }
  };
  
  return processedRequests;
};

};
  
