<!DOCTYPE html>
     <html>
     <head>
          <title>Registrar usuario</title>
          <meta charset="utf-8">
          <link rel="stylesheet" type="text/css" href="css/user.css">
          
     </head>
     <body style="background-image: url('img/ezgif.com-gif-maker.gif'); background-size: cover; height: 100vh; padding:0; margin:0;">
          <form method="post" style="background-color: rgba(8, 11, 12, 0.00);">
               <h1 style="color: #fff;">¡Registrate!</h1>
               <input type="text" name="name" placeholder="Nombre completo">
               <input type="email" name="email" placeholder="Email">
               <input type="password" name="passw" placeholder="Contraseña">
               <input type="text" name="cp" placeholder="Código Postal">
               <input type="text" name="address" placeholder="Dirección de envíos">
               <input type="submit" name="register" value="Registrarse">
          </form>
          <?php
               include("form.php");
          ?>
     </body>
</html>