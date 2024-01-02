import 'package:meowdical/PhotoAlbum/Model/modelPhoto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PhotoController {

  CollectionReference photos = FirebaseFirestore.instance.collection('files');

  Future upload(ModelPhoto photo) async {
    await photos.add({
      'nameOfPicture': photo.nomDeLaPhoto,
      'description': photo.description,
      'linkOfPicture' : photo.lienPhoto,
    });
  }  
  Future<List<ModelPhoto>> recuperationModel() async {
    List<ModelPhoto> list = [];
    // QuerySnapshot c'est un resultat d'une requete qui a une collection de doc, il contient des DocumentSnapshot qui sont un des doc le la collection
    await photos.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) { // querysnapshot.docs, la partie "docs" est une propriete qui liste les documentSnapshot que la requette renvoie
        list.add(ModelPhoto(
          nomDeLaPhoto: doc["nameOfPicture"],
          description: doc["description"],
          lienPhoto: doc["linkOfPicture"],
        ));
      });
    });
    return list;
  }
  
}


  // Future<List<String>> downloadURLs() async {
  //   final ref = FirebaseStorage.instance.ref().child('files');
  //   final result = await ref.listAll();
  //   final imageRefs = result.items;

  //   return await Future.wait(imageRefs.map((ref) => ref.getDownloadURL()));
  // }
