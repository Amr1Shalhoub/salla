// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:messenger_design2/layout/shop_app/shop_app_cubit/cubit.dart';
// import 'package:messenger_design2/models/shop_app/home_model.dart';
// //import 'package:messenger_design2/layout/shop_app/shop_app_cubit/cubit.dart';
// import 'package:messenger_design2/modules/shop_app/search/cubit/cubit.dart';
// import 'package:messenger_design2/modules/shop_app/search/cubit/states.dart';
// import 'package:messenger_design2/shared/components/components.dart';
//
// class SearchScreen extends StatelessWidget {
//   //const SearchScreen({Key? key}) : super(key: key);
//   var formkey=GlobalKey<FormState>();
//   var searchController=TextEditingController();
//   var text;
//
//  late List<ProductModel> searchProducts;
//
//  void addItemsToSearchList(String searchText)
//  {
//    searchProducts=allProducts.where((ProductModel) => ProductModel.name.toLowerCase().startsWith(searchText)).toList();
//    print(searchProducts[0].name);
//
//
//  }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (BuildContext context) =>SearchCubit(),
//
//       child: BlocConsumer<SearchCubit,SearchStates>(
//         listener: (context,state){
//
//           //allProducts=ShopCubit.get(context).homeModel.data.products;
//
//         },
//         builder: (context,state)
//         {
//           return Scaffold(
//             appBar: AppBar(),
//             body:Form(
//               key: formkey,
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//                     defaultFormField(
//                       onChange: (searchText){
//                         addItemsToSearchList(searchText);
//
//                       },
//                         prefix: Icons.search,
//                         type: TextInputType.text,
//                         controller: searchController,
//                         validate: ( value)
//
//                         {
//                           if(value!.isEmpty)
//                             {
//                               return 'Enter a text to search';
//                             }
//                           return null;
//                         },
//                         label: 'Search',
//                       onSubmit: (String value)
//                       {
//                         text=value;
//                         SearchCubit.get(context).Search(value);
//                       },
//
//                     ),
//                     SizedBox(height: 10.0,),
//                     if(state is SearchLoadingState)
//                     LinearProgressIndicator(),
//                     SizedBox(height: 10.0,),
//                     if(state is SearchSuccessState)
//                     Expanded(
//                       child: ListView.separated(
//                         itemBuilder: (context,index)=> BuildListProduct(
//                           // ShopCubit.get(context).favoritesModel.data!.data![index]
//
//                             SearchCubit.get(context).model.data!.data![index], text,context,isOloPrice: false
//                         ),
//                         separatorBuilder: (context,index)=>myDivider(),
//                         itemCount: SearchCubit.get(context).model.data!.data!.length,
//                         //ShopCubit.get(context).categoriesModel.data.data.length,
//                       ),
//                     ),
//
//
//
//                   ],
//                 ),
//               ),
//             )
//           );
//
//         },
//
//       ),
//     );
//   }
// }
//
//
//
//
//



import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_design2/layout/shop_app/shop_app_cubit/cubit.dart';
import 'package:messenger_design2/models/shop_app/home_model.dart';
//import 'package:messenger_design2/layout/shop_app/shop_app_cubit/cubit.dart';
import 'package:messenger_design2/modules/shop_app/search/cubit/cubit.dart';
import 'package:messenger_design2/modules/shop_app/search/cubit/states.dart';
import 'package:messenger_design2/shared/components/components.dart';
import 'package:messenger_design2/shared/styles/colors.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //const SearchScreen({Key? key}) : super(key: key);
  var formkey=GlobalKey<FormState>();

  var searchController=TextEditingController();

  var text;

   List<ProductModel> searchProducts=[];

  void addItemsToSearchList(String searchText)
  {
    // Very important line of code
    // This is the trick of how we can search like it is real time searching
    if (searchText!=''||searchText!=null)
    searchProducts=allProducts.where((ProductModel) => ProductModel.name.toLowerCase().startsWith(searchText)).toList();
    //print(searchProducts[0].name);


  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>SearchCubit(),

      child: BlocConsumer<SearchCubit,SearchStates>(
        listener: (context,state){

          //allProducts=ShopCubit.get(context).homeModel.data.products;

        },
        builder: (context,state)
        {
          return Scaffold(
              appBar: AppBar(),
              body:Form(
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      defaultFormField(
                        onChange: (searchText){
                          setState(() {
                            if(searchText!=null||searchText!='')
                            addItemsToSearchList(searchText);
                            else {
                              searchProducts=[];
                            }

                          });


                        },
                        prefix: Icons.search,
                        type: TextInputType.text,
                        controller: searchController,
                        validate: ( value)

                        {
                          if(value!.isEmpty)
                          {
                            return 'Enter a text to search';
                          }
                          return null;
                        },
                        label: 'Search',
                        // onSubmit: (String value)
                        // {
                        //   text=value;
                        //   SearchCubit.get(context).Search(value);
                        // },

                      ),
                      SizedBox(height: 20.0,),

                        Expanded(
                          child: ConditionalBuilder(
                            condition:searchProducts.isNotEmpty||searchProducts==[],
                            fallback:(context)=>Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text('No Results',style: TextStyle(
                                  color: Colors.grey,
                                ),
                                ),
                                ),
                              ],
                            ) ,
                            builder:(context)=>ListView.separated(
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context,index)=> BuildSearchProduct(
                                // ShopCubit.get(context).favoritesModel.data!.data![index]

                                 searchProducts[index],context,isOloPrice: false
                              ),
                              separatorBuilder: (context,index)=>myDivider(),
                              itemCount: searchProducts.length,
                              //ShopCubit.get(context).categoriesModel.data.data.length,
                            ) ,

                          ),
                        ),



                    ],
                  ),
                ),
              )
          );

        },

      ),
    );
  }

  Widget BuildSearchProduct( model,context,{bool isOloPrice=true})=>Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      height: 120.0,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [

          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image:CachedNetworkImageProvider('${model.image}'),
                //fit: BoxFit.cover,
                width: 100,
                height: 120,



              ),
              if(model.discount !=0&&isOloPrice)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  color: Colors.red,
                  child: Text(
                    'Discount',style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white

                  ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 20.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      height: 1.3
                  ),
                ),
                Spacer(),
                Row(
                  children:
                  [
                    Text(
                      '${model.price}',


                      style: TextStyle(
                        fontSize: 16.0,
                        color: defaultColor,

                        height: 1.3,

                      ),
                    ),
                    SizedBox(width: 5.0,),
                    if(model.discount!=0&& isOloPrice)
                      Text(
                        '${model.oldPrice}',


                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,

                          height: 1.3,

                        ),
                      ),
                    Spacer(),
                    IconButton(
                      // padding: EdgeInsets.zero,
                      onPressed: ()
                      {
                        ShopCubit.get(context).ChangeFavorites(model!.id!);

                        // print(model.id);
                      },
                      icon: CircleAvatar(
                        radius: 15,
                        backgroundColor:ShopCubit.get(context).favorites[model!.id]?? false ? defaultColor:Colors.grey,

                        //true ? defaultColor:Colors.grey,
                        //ShopCubit.get(context).favorites[model.id]! ?defaultColor:Colors.grey,
                        //ShopCubit.get(context)!.favorites[model.id] ? defaultColor : Colors.grey,
                        child: Icon(Icons.favorite_border,color: Colors.white,),
                      ),
                    ),
                  ],

                ),
              ],
            ),
          ),
        ],

      ),
    ),
  );
}





