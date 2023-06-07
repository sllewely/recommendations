import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/oauth2_client.dart';

OAuth2Client client = OAuth2Client(
    authorizeUrl: '127.0.0.1:3000/oauth/authorize',
    tokenUrl: '127.0.0.1:3000/oauth/token',
    redirectUri: 'my.test.app:/oauth2redirect',
    customUriScheme: 'my.test.app'
);

OAuth2Helper oAuth2Helper = OAuth2Helper(client,
    
    clientId: clientId)