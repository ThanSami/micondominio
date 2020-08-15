import 'package:micondominio/cambiarContrasenaPage.dart';
import 'package:flutter/material.dart';
import 'package:micondominio/listaVisitasPage.dart';
import 'package:micondominio/panicoPage.dart';
import 'package:micondominio/visitaPage.dart';
import 'constantes.dart';
import 'loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'listatomas.dart';

class Principal extends StatefulWidget{


  @override
  State createState() => PrincipalState();
}

class PrincipalState extends State<Principal> with TickerProviderStateMixin {
  final appTitle = 'Menu Principal';
  String _idUsuario = "";
  String _email = "";
  String _nombreUsuario = "";
  String _tipoUsuario = "";

  int _currentIndex = 0;

  List<ListTile> listaMenu = [];
  List<_NavigationIconView> _navigationViews;


  _clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUsuario = (prefs.getString('idUsuario') ?? '');
      _nombreUsuario = (prefs.getString('nombreUsuario') ?? '');
      _email = (prefs.getString('correoUsuario') ?? '');
      _tipoUsuario = (prefs.getString('tipoUsuario') ?? '');
    });
  }


  @override
  void initState() {
    super.initState();

    if (_navigationViews == null) {
      _navigationViews = <_NavigationIconView>[
        _NavigationIconView(
          icon: const Icon(Icons.add_comment),
          title: 'Nueva Visita',
          vsync: this,
        ),
        _NavigationIconView(
          icon: const Icon(Icons.add_alert),
          title: 'Botón Panico',
          vsync: this,
        ),
      ];

      _navigationViews[_currentIndex].controller.value = 1;
    }

    _loadUser();
  }


  @override
  Widget build(BuildContext context) {
    var bottomNavigationBarItems = _navigationViews
        .map<BottomNavigationBarItem>((navigationView) => navigationView.item)
        .toList();

      _currentIndex =
          _currentIndex.clamp(0, bottomNavigationBarItems.length - 1).toInt();


    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        backgroundColor: Constantes.colorPrimario,
        actions: <Widget>[
          /*Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                    Icons.more_vert
                ),
              )
          ),*/
          PopupMenuButton<int>( // overflow menu
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child:Row(
                  children: <Widget>[
                    Icon(Icons.settings),
                    Text('Cambiar contraseña'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    Text('Salir'),
                  ],
                ),
              ),
            ],
            onSelected: (value){
              switch(value)
              {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CambiarContrasenaPage()),
                  );
                  break;
                case 2:
                  _clearUser();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginPage()),
                  );
                  break;
              }
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(child: Image(image: AssetImage('images/logoshadow.png'),) ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: _buildDrawerList(context)
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        items: bottomNavigationBarItems,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 20.0,
        unselectedFontSize: 18.0,
        onTap: (index) {
          switch(index)
          {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VisitaPage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PanicoPage()),
              );
              break;
          }
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Constantes.colorBoton,
      ),
    );
  }

  List<Widget> _buildDrawerList(BuildContext context) {
    List<Widget> children = [];
    children..addAll(_buildUserAccounts(context))
            ..addAll(_ListaVisitas(context))
            ..addAll(_NuevaVisita(context));

    //..addAll([new Divider()])
    //..addAll(_buildLabelWidgets(context))
    //..addAll([new Divider()])
    //..addAll(_buildActions(context))
    //..addAll([new Divider()])
    //..addAll(_buildSettingAndHelp(context));
    return children;
  }

  List<Widget> _buildUserAccounts(BuildContext context) {
    return [
      new UserAccountsDrawerHeader(
        accountName: Text(_nombreUsuario),
        accountEmail: Text(_email == '' ? _idUsuario : _email),
        currentAccountPicture: new CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('images/myAvatar.png') ,

        ),
      )
    ];
  }

  List<Widget> _ListaVisitas(BuildContext context) {
    return [
      new ListTile(
        title: Row(
          children: <Widget>[
            Icon(Icons.format_list_bulleted),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Lista Visitas'),
            )
          ],
        ),
        onTap: () =>
        {
          Navigator.pop(context),
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ListaVisitasPage()),
          )
        },
      ),
    ];
  }

  List<Widget> _NuevaVisita(BuildContext context) {
    return [
      new ListTile(
        title: Row(
          children: <Widget>[
            Icon(Icons.airport_shuttle),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Nueva Visita'),
            )
          ],
        ),
        onTap: () =>
        {
          Navigator.pop(context),
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VisitaPage()),
          )
        },
      ),
    ];
  }

}

class _NavigationIconView {
  _NavigationIconView({
    this.title,
    this.icon,
    TickerProvider vsync,
  })  : item = BottomNavigationBarItem(
    icon: icon,
    title: Text(title),
  ),
        controller = AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = controller.drive(CurveTween(
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    ));
  }

  final String title;
  final Widget icon;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  Animation<double> _animation;

  FadeTransition transition(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Stack(
        children: [
          ExcludeSemantics(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/demos/bottom_navigation_background.png',
                    package: 'flutter_gallery_assets',
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: IconTheme(
              data: const IconThemeData(
                color: Colors.white,
                size: 80,
              ),
              child: Semantics(
                label: title,
                child: icon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

