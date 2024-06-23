import "package:app_barbearia/Model/Horario.dart";

class Validacoes{

  
 bool verificaInserirHorarioDisponivel(Horario time, userType){

  if(userType == "usuario2"){
    if(time.disponivel == true){
      return false;
    }else{
      return true;
    }
  }

  return false;
 }

  bool verificarDesmarcarHorario(Horario time, userType){

    if(time.disponivel == true){ // to do verificar se ja existe esse horario na lista de marcados 
      return false;
    }else{
      return true;
    }
  }

  bool verificaMarcarHorario(Horario time, userType){
    if(userType == "usuario1"){
      if(time.disponivel == false){
        return false;
      }else{
        return true;
      }
    }
    return false;
 }

 

 
  


}