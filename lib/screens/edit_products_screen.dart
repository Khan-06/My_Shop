import 'package:flutter/material.dart';
import '../providers/product.dart';

class EditProductsScreen extends StatefulWidget {
  const EditProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-products';

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', description: '', title: '', imageUrl: '', price: 0);

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState?.save();
    print(_editedProduct.imageUrl);
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _priceFocusNode,
                onSaved: (newValue) => _editedProduct = Product(
                    id: _editedProduct.id,
                    description: _editedProduct.description,
                    title: newValue!,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price),
              ),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (value) => _descriptionNode,
                  onSaved: (newValue) => _editedProduct = Product(
                        id: _editedProduct.id,
                        description: _editedProduct.description,
                        title: _editedProduct.title,
                        imageUrl: _editedProduct.imageUrl,
                        price: double.parse(newValue!),
                      ),),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                focusNode: _descriptionNode,
                keyboardType: TextInputType.multiline,
                  onSaved: (newValue) => _editedProduct = Product(
                      id: _editedProduct.id,
                      description: newValue!,
                      title: _editedProduct.title,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price)
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 15, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Center(child: Text('Enter URL'))
                        : FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(_imageUrlController.text),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onEditingComplete: () => setState(() {}),
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) => _saveForm(),
                        onSaved: (newValue) => _editedProduct = Product(
                            id: _editedProduct.id,
                            description: _editedProduct.description,
                            title: _editedProduct.title,
                            imageUrl: newValue!,
                            price: _editedProduct.price)

                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
