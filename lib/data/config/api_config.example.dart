// Archivo de ejemplo para configuración de la API
// Copia este archivo y ajusta la URL según tu entorno

class ApiConfigExample {
  // ========================================
  // CONFIGURACIÓN DE ENTORNOS
  // ========================================
  
  // 🔧 Para EMULADOR ANDROID:
  // static const String baseUrl = 'http://10.0.2.2:8000';
  
  // 🔧 Para SIMULADOR iOS:
  // static const String baseUrl = 'http://localhost:8000';
  
  // 🔧 Para DISPOSITIVO FÍSICO (en la misma red WiFi):
  // static const String baseUrl = 'http://192.168.1.100:8000';
  // Reemplaza 192.168.1.100 con tu IP local
  
  // 🔧 Para SERVIDOR DE PRODUCCIÓN:
  // static const String baseUrl = 'https://tu-servidor.com';
  
  
  // ========================================
  // CÓMO ENCONTRAR TU IP LOCAL
  // ========================================
  
  // Windows PowerShell/CMD:
  // ipconfig
  // Busca: "Dirección IPv4" en la sección de tu adaptador de red WiFi/Ethernet
  
  // Mac Terminal:
  // ifconfig | grep "inet "
  // Busca algo como: inet 192.168.1.100
  
  // Linux:
  // hostname -I
  // o
  // ip addr show
  
  
  // ========================================
  // NOTAS IMPORTANTES
  // ========================================
  
  // 1. Si usas emulador Android:
  //    - 10.0.2.2 apunta al localhost de tu máquina host
  //    - NO uses 127.0.0.1 o localhost
  
  // 2. Si usas dispositivo físico:
  //    - Tu computadora y el dispositivo deben estar en la misma red
  //    - El backend debe correr con: python manage.py runserver 0.0.0.0:8000
  //    - Verifica que tu firewall permita conexiones en el puerto 8000
  
  // 3. Si las imágenes no cargan:
  //    - Verifica que el MEDIA_URL en Django settings.py sea accesible
  //    - Las URLs de imágenes deben ser absolutas, no relativas
  
  // 4. CORS (si hay problemas):
  //    - Asegúrate de tener django-cors-headers instalado
  //    - Configura CORS_ALLOWED_ORIGINS en settings.py
}
