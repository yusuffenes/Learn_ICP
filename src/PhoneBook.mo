
// importlar 

import Map "mo:base/HashMap";
import Text "mo:base/Text";

//actor -canister - smart contract
actor  {
  // Motoko  -> Type Language
  type Name = Text;
  type Phone =Text;
  type Entry = 
  {
    desc : Text;
    phone : Phone;
  };
  // variable  var = mutable let = immutable
  let PhoneBook = Map.HashMap<Name,Entry>(0,Text.equal,Text.hash);


  // fonskiyonlar 
  // query sorgulamak


  public func insert(name:Name,entry:Entry) : async () {
    PhoneBook.put(name,entry);
  };
  public query func lookup(name:Name) : async ?Entry {
    PhoneBook.get(name);
  };
  public func delete(name:Name) : async ?Entry  {
    PhoneBook.remove(name);
  };
  public func update(name:Name,entry:Entry) : async ?Entry {
    PhoneBook.replace(name,entry);
  };
 

}
