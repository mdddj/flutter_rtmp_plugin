/// 内核引擎
enum ManagerModel { exo2PlayerManager, systemPlayerManager, ijkPlayerManager }
extension ManagerModelExt on ManagerModel {
  int get index {
    switch(this){
      case ManagerModel.exo2PlayerManager:
        return 0;
      case ManagerModel.systemPlayerManager:
        return 1;
      default:
        return -1;
    }
  }
}