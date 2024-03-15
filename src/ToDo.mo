import Map  "mo:base/HashMap";
import Hash  "mo:base/Hash";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";



actor Main {
  type ToDo = {
    description: Text;
    done: Bool;

  };
  func natHash(n: Nat): Hash.Hash {
    Text.hash(Nat.toText(n));
  };

  var todos = Map.HashMap<Nat, ToDo>(0,Nat.equal,natHash);
  var nextId:Nat = 0;
  public query func getTodos(): async [ToDo] {
    Iter.toArray(todos.vals());
  };
  public func addTodo(description: Text): async Nat {
    let id = nextId;
    nextId += 1; 
    todos.put(id, {description=description; done= false});
    id;
  };
  public func doneTodo(id:Nat) :async (){
    ignore do ? {let description = todos.get(id)!.description; todos.put(id, {description; done=true})};
  };
  public query func showTodo() : async Text {
    var output : Text = "\n__________TO-DO__________\n";
    for (todo:ToDo  in todos.vals()){
      output #= "\n" # todo.description;
      if (todo.done){output #= " +" };
      
    };
    output # "\n"
  };
  public func clearCompleted() : async () {
    todos := Map.mapFilter<Nat, ToDo, ToDo>(todos, Nat.equal, natHash, 
    func(_, todo) { if (todo.done) null else ?todo });
  };

}