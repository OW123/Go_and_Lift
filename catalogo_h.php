<?php
    include("form.php");
    function fn02_post(){
        $server = "148.239.60.61";
        $user = "ids";
        $passwordBD = "ids";
        $db = "bd_goandlift";
        $connInfo = array("Database"=>$db, "UID"=>$user, "PWD"=>$passwordBD);

        $conexion = sqlsrv_connect($server,$connInfo);

        if ($conexion){
            //echo "Conectado";
            $strSQl = "SELECT * FROM Productos";
            $resultados = sqlsrv_query($conexion, $strSQl);

            if($resultados == true){
                //$fila = sqlsrv_fetch_array($resultados,SQLSRV_FETCH_ASSOC);
                //echo $fila["Nombre"];
                while($fila = sqlsrv_fetch_array($resultados,SQLSRV_FETCH_ASSOC)){
                    $registro[] = $fila;
                }
                $strJSON = json_encode($registro);
                echo $strJSON;
            }


        }
        else{
            echo "No conectado";
            die(print_r(sqlsrv_errors()));
        }
    }//Fin función fn02_post

    function delete($IdProducto, $Cantidad){
        $conn = conectar();
        $rs[]=null;
        if($conn){
            $strSQl = "EXEC QuitaProducto $IdProducto, $Cantidad ";
            $resultados = sqlsrv_query($conn, $strSQl);
            //echo $strSQl;
            //echo "***".sqlsrv_fetch_array($resultados);
            if($resultados == true){
                $rs[0]="ok";
                //sqlsrv_next_result($resultados);
                //$rs = 
                /*
                while($fila = sqlsrv_fetch_array($resultados)){
                    echo "****".$fila;
                    $registro[] = $fila;
                }*/
                //echo "-----".$fila;
                /*
                while($fila = sqlsrv_fetch_array($resultados,SQLSRV_FETCH_ASSOC)){
                    echo "****".$fila;
                    $registro[] = $fila;
                }
                
                $strJSON = json_encode($registro);
                echo $strJSON;
                */
                echo json_encode($rs);
            }


        }
    }
    function AgregarTicket($IdCliente){
        $conn = conectar();
        if($conn){
            $strSQl = "EXEC AgregaTicket $IdCliente ,'Tarjeta','19000101'";
            $resultados = sqlsrv_query($conn, $strSQl);
            //echo $strSQl;
            if($resultados == true){
                while($fila = sqlsrv_fetch_array($resultados,SQLSRV_FETCH_ASSOC)){
                    //echo "****".$fila;
                    $registro[] = $fila;
                }
                $strJSON = json_encode($registro);
                echo $strJSON;
                //$rs[0]="ok";
                //echo json_encode($rs);
            }
        }
    }

    if(isset($_GET["add_Ticket"]))
        AgregarTicket($_GET["IdCliente"]);

    //if(isset($_GET["w"]))
      //  AgregarTicket($_GET["c"]);
        //AgregaTicket($_POST["IdCliente"]);
        //POts
    if(isset($_POST["variablePost_2"]))
        delete($_POST["IdProducto"], 1);
    
    if(isset($_GET["x"]))
        delete(4, 1);

    if(isset($_POST["variablePost"]))
        fn02_post();
?>