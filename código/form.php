<?php

    function conectar(){

        $servidor = "148.239.60.61";
        $usuarioDB = "ids";
        $passwordDB = "ids";
        $db ="bd_goandlift";
        $connInfo = array("Database" => $db, "UID" => $usuarioDB, "PWD" => $passwordDB, "Characterset" => "UTF-8");

        $conexion = sqlsrv_connect($servidor, $connInfo);

        return $conexion;
    }

    function agregarUsuario($n,$ce,$pas,$cp,$dr){
        $conn = conectar();
        if($conn){
            $strI = "exec AgregaCliente '$n', '$ce', '$pas', '$cp', '$dr' ";
            $resultado = sqlsrv_query($conn, $strI);
            if($resultado == true){
                ?>
                <button  type="button" onclick="parent.location='sesion_started.html'">Regresar</button>
                <h3 class="ok">¡Te has registrado correctamente!</h3>
                <?php
            }
        }
        else{
            ?>
                <h3 class="bad">¡Registro no exitoso!</h3>
            <?php
        }
    }
        
    
    if(isset($_POST["name"]))
        agregarUsuario($_POST["email"],$_POST["name"],$_POST["passw"],$_POST["cp"],$_POST["address"],$_POST["register"]);

?>