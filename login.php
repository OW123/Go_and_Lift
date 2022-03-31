<?php
    require '../form.php';
    session_start();

    $usuario = $_POST['usuario'];
    $clave = $_POST['clave'];
    $conn = conectar();

    if($conn){

        $q = "select count(*) as contar,IdCliente from Cliente where correo = '$usuario' and contraseña = '$clave' group by IdCliente";
        echo $q;
        $resultado = sqlsrv_query($conn, $q);
        if($resultado == true){
            while($fila = sqlsrv_fetch_array($resultado, SQLSRV_FETCH_ASSOC)){
                $registros[] = $fila;
                echo $fila["contar"];
              if( $fila["contar"] == "1"){
                  //echo "mandar otro llado";
               $_SESSION['username'] = $usuario;
               setcookie("IdCliente",$fila["IdCliente"],time()+3600,"/");
               //$_COOKIE["idCliente"] = $fila["IdCliente"];
                header("location: ../catalogo_h.html");
              }
            }
            //echo $registros[0];
 
            
        }
    }
    else{
        echo "no conectado";
    }

    /*
    $consulta = sqlsrv_query($conn, $q);
    $array = sqlsrv_fetch_array($consulta);
    echo $array;

    if($array['contar']>0){
        $_SESSION['username'] = $usuario;
        header("location: paginaprincipal.php");
    }
    else{
        echo "datos incorrectos";
    }
    */
?>
