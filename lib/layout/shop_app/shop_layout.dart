import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:messenger_design2/layout/shop_app/shop_app_cubit/cubit.dart';
import 'package:messenger_design2/layout/shop_app/shop_app_cubit/states.dart';
//import 'package:messenger_design2/modules/shop_app/login/shop_login_screen.dart';
import 'package:messenger_design2/shared/components/components.dart';
//import 'package:messenger_design2/shared/network/local/cache_helper.dart';

import '../../modules/shop_app/search/search_screen.dart';
import '../../shared/components/constants.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);



  Widget buildNoInternetWidget()=>Center(
    child: Container(
      color: Colors.white,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height:20.0),
          Text('Can\'t Connect... ',style: TextStyle(
            color: Colors.grey,
            fontSize: 22.0,

          ),
          ),
          SizedBox(height: 10,),
          Text('Check Your Internet Connection ',style: TextStyle(
            color: Colors.grey,
            fontSize: 22.0,

          ),
          ),
          Image.asset('assets/images/disconnection.png'),
        ],
      ) ,
    ),
  );
  @override
  Widget build(BuildContext context) {


    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state)
      {
        // if(state is ShopLoadingUserDataState)
        // {
        //   Userhomedata(context);
        // }

      },
      builder: (context,state)
      {

        var cubit=ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Salla',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            actions:
            [
              // TextButton(onPressed:(){
              //   Siginout(context);
              // }, child: Text('Sign Out')),
            IconButton(
                onPressed: ()
                {
                  navigateTo(context, SearchScreen());
                },
                icon: Icon(Icons.search),
            )
            ],
          ),
          body:OfflineBuilder(
            connectivityBuilder: (
      BuildContext context,
      ConnectivityResult connectivity,
      Widget child,
      ){
              final bool connected = connectivity != ConnectivityResult.none;
              if(connected)
                {
                  return cubit.bottomscreens[cubit.currentIndex];
                }
              else{
                return buildNoInternetWidget();

              }
            },
            child: Center(child: CircularProgressIndicator(),)
            ),

          bottomNavigationBar: BottomNavigationBar(
            onTap: (index)
            {
              cubit.ChangeBottomNav(index);
            },
            currentIndex: cubit.currentIndex,
            items: [
              BottomNavigationBarItem(icon:Icon(Icons.home,),label: 'Home'),
              BottomNavigationBarItem(icon:Icon(Icons.apps,),label: 'Categories'),
              BottomNavigationBarItem(icon:Icon(Icons.favorite,),label: 'Favorites'),
              BottomNavigationBarItem(icon:Icon(Icons.settings,),label: 'Settings'),
            ],
          ),
        );

      },

    );
  }
  Userhomedata(context){

    ShopCubit.get(context).getHomeData();
    ShopCubit.get(context).getCategories();
    ShopCubit.get(context).getFavorites();
    ShopCubit.get(context).getUserData();

  }


}
