import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // final _priceFocusNode = FocusNode();
  // final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  bool _isInit = true;
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  bool _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
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
    _imageUrlFocusNode.removeListener(_updateImageURL);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.startsWith('http') ||
          (!_imageUrlController.text.endsWith('jpg') &&
              !_imageUrlController.text.endsWith('png') &&
              !_imageUrlController.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      if (_editedProduct.id == null) {
        print('Adding product');
        Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct)
            .catchError((error) {
          print('Caught Error');
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An error occured!'),
              content: Text('Something went wong.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okay'),
                ),
              ],
            ),
          );
        }).then((_) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        });
      } else {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(label: Text('Title')),
                        textInputAction: TextInputAction.next,
                        // onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocusNode),
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: newValue,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a title.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],

                        decoration: InputDecoration(label: Text('Price')),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        // focusNode: _priceFocusNode,
                        // onFieldSubmitted: (_) => FocusScope.of(context)
                        // .requestFocus(_descriptionFocusNode),
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(newValue),
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid price';
                          }
                          if (double.tryParse(value) <= 0) {
                            return 'Please enter a number greater than zero';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],

                        decoration: InputDecoration(label: Text('Description')),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        // focusNode: _descriptionFocusNode,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: newValue,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a description.';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long.';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _saveForm();
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: newValue,
                                  isFavorite: _editedProduct.isFavorite,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide a image URL.';
                                }
                                if (!value.startsWith('http')) {
                                  return 'Please enter a valid URL.';
                                }
                                if (!value.endsWith('jpg') &&
                                    !value.endsWith('png') &&
                                    !value.endsWith('jpeg')) {
                                  return 'Please enter a valid image URL.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
