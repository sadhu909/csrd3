class UserModel{

  final String name;
  final String email;
  final int age;

  UserModel(this.name, this.email, this.age);
  Map<String, dynamic> toMap(){
    return{
      'name' : name,
      'email' : email,
      'age' : age,
    };
  }
}

