### Documentación del IDE BOX 3.3 para Linux

---

#### **Introducción**
El IDE BOX 3.3 es un entorno de desarrollo integrado básico desarrollado con GTK+ 3, diseñado para ejecutar y analizar comandos personalizados, tales como declaraciones de variables, impresiones en pantalla y operaciones simples. Está pensado para aprender conceptos básicos de programación en un entorno amigable.

---

### **Instalación en Linux**

1. **Requisitos previos**
   - Asegúrate de tener instaladas las siguientes dependencias:
     ```bash
     sudo apt update
     sudo apt install build-essential libgtk-3-dev gcc make
     ```

2. **Clonar el repositorio**
   Si el código fuente está en un repositorio, clónalo:
   ```bash
   git clone https://github.com/tuusuario/ide-box.git
   cd ide-box
   ```

3. **Compilación**
   Compila el proyecto con GCC:
   ```bash
   gcc -o ide-box ide_box.c `pkg-config --cflags --libs gtk+-3.0`
   ```

4. **Ejecución**
   Ejecuta el programa compilado:
   ```bash
   ./ide-box
   ```

---

### **Uso del IDE BOX 3.3**

#### **Interfaz**
1. **Editor**
   - Escribe tus comandos en el editor principal. Los comandos reconocidos incluyen:
     - `mostrar ("mensaje");` — Muestra el mensaje en la salida.
     - `entero nombre = valor;` — Declara una variable entera.
     - `decimal nombre = valor;` — Declara una variable decimal.
     - `lógico nombre = verdadero/falso;` — Declara una variable booleana.
     - `nulo nombre;` — Declara una variable nula.

2. **Salida**
   - Muestra los resultados o errores tras ejecutar el código.

3. **Notificaciones**
   - Una barra inferior informa sobre acciones realizadas en el IDE.

#### **Menú y herramientas**
- **Archivo**:
  - **Abrir**: Abre un archivo con código.
  - **Guardar**: Guarda el contenido del editor en un archivo.

- **Botones de herramientas**:
  - **Ejecutar**: Procesa el código del editor y muestra los resultados.
  - **Limpiar Editor**: Borra el contenido del editor.
  - **Limpiar Salida**: Borra los resultados de la salida.
  - **Ayuda**: Muestra información sobre los comandos disponibles.
  - **Zoom In/Out**: Ajusta el tamaño del texto en el editor.

---

### **Características Técnicas**
1. **Tecnologías utilizadas**:
   - GTK+ 3 para la interfaz gráfica.
   - Lenguaje C para la implementación del backend.

2. **Arquitectura**:
   - **Editor de texto**: Basado en `GtkTextView`.
   - **Procesamiento de comandos**: Validación y ejecución personalizada de instrucciones simples.

---

### **Extensiones y Personalización**

#### **Extender comandos**
- Agrega nuevos comandos personalizando la función `execute_code`. Por ejemplo:
  ```c
  if (g_str_has_prefix(trimmed_line, "nuevo_comando ")) {
      // Procesa el nuevo comando aquí.
  }
  ```

#### **Resaltado de sintaxis**
- Integra `GtkSourceView` para un editor con resaltado de sintaxis.

#### **Temas personalizados**
- Permite cambiar temas con `gtk_widget_override_background_color`.

---

### **Resolución de problemas**
1. **Error: gtk/gtk.h no encontrado**
   - Asegúrate de tener instalado `libgtk-3-dev`:
     ```bash
     sudo apt install libgtk-3-dev
     ```

2. **Error en la ejecución del código**
   - Verifica la sintaxis del comando. Consulta la sección de ayuda en el menú.

3. **Problemas de compilación**
   - Asegúrate de incluir las dependencias correctas:
     ```bash
     gcc -o ide-box ide_box.c `pkg-config --cflags --libs gtk+-3.0`
     ```

---

### **Licencia**
Este proyecto es de código abierto. Puedes distribuirlo y modificarlo bajo los términos de la [Licencia MIT](https://opensource.org/licenses/MIT).

