import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

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
      Product(id: '', description: '', title: '', imageUrl: '', price: 0.1);

  var _initValues = {
    //Initial Values!
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id.isNotEmpty) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editedProduct);
      } catch (error) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('An Error Occurred!'),
            content: const Text('Something went wrong'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'))
            ],
          ),
        );
      }
      {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      }
    }
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => _priceFocusNode,
                      onSaved: (newValue) => _editedProduct = Product(
                        id: _editedProduct.id,
                        description: _editedProduct.description,
                        title: newValue!,
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite,
                        price: _editedProduct.price,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                    ), // Title
                    TextFormField(
                      initialValue: _initValues['price'],
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
                        isFavorite: _editedProduct.isFavorite,
                        price: double.parse(newValue!),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid amount.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter the price greater than zero';
                        }
                        return null;
                      },
                    ), // Price
                    TextFormField(
                        initialValue: _initValues['description'],
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        focusNode: _descriptionNode,
                        keyboardType: TextInputType.multiline,
                        onSaved: (newValue) => _editedProduct = Product(
                            id: _editedProduct.id,
                            description: newValue!,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the description.';
                          }
                          if (value.length < 10) {
                            return 'The description should be at least 10 characters long.';
                          }
                          return null;
                        }), // Description
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
                                  child:
                                      Image.network(_imageUrlController.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: _initValues['imageUrl'],
                            decoration:
                                const InputDecoration(labelText: 'Image Url'),
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
                                isFavorite: _editedProduct.isFavorite,
                                price: _editedProduct.price),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a image Url.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid Url.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid Url';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ) // Image
                  ],
                ),
              ),
            ),
    );
  }
}

//https://cdn.pixabay.com/photo/2023/04/23/09/40/bird-7945398_1280.jpg
