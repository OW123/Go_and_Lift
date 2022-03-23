<!DOCTYPE html>
     <html>
     <head>
          <title>Registrar usuario</title>
          <meta charset="utf-8">
          <link rel="stylesheet" type="text/css" href="css/user.css">
          
     </head>
     <body>
          <form method="post">
               <h1>¡Registrate!</h1>
               <input type="text" name="name" placeholder="Nombre completo">
               <input type="email" name="email" placeholder="Email">
               <input type="password" name="passw" placeholder="Contraseña">
               <input type="text" name="cp" placeholder="Código Postal">
               <input type="text" name="address" placeholder="Dirección de envíos">
               <input type="submit" name="register" value="Registrarse">
          </form>
          <?php
               include("registrar.php");
          ?>
     </body>
</html>
