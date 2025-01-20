#include <gtk/gtk.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

// Variables globales
GtkWidget *editor_text;
GtkWidget *output_text;
GtkWidget *notification_bar; // Barra de notificaciones

// Prototipos
void execute_code(GtkWidget *widget, gpointer user_data);
void clear_editor(GtkWidget *widget, gpointer user_data);
void clear_output(GtkWidget *widget, gpointer user_data);
void save_file(GtkWidget *widget, gpointer window);
void open_file(GtkWidget *widget, gpointer window);
void show_help(GtkWidget *widget, gpointer window);
void zoom_in(GtkWidget *widget, gpointer user_data);
void zoom_out(GtkWidget *widget, gpointer user_data);
void append_to_notification(const char *message);
void update_notification(const char *message);

// Función para agregar notificaciones
void append_to_notification(const char *message) {
    GtkTextBuffer *notif_buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(notification_bar));
    gtk_text_buffer_set_text(notif_buffer, message, -1);
    GtkTextIter iter;
    gtk_text_buffer_get_end_iter(notif_buffer, &iter);
    gtk_text_view_scroll_to_iter(GTK_TEXT_VIEW(notification_bar), &iter, 0.0, FALSE, 0.0, 0.0);
}

// Función para limpiar el editor
void clear_editor(GtkWidget *widget, gpointer user_data) {
    GtkTextBuffer *editor_buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(editor_text));
    gtk_text_buffer_set_text(editor_buffer, "", -1);
    append_to_notification("Editor limpiado.");
}

// Función para limpiar la salida
void clear_output(GtkWidget *widget, gpointer user_data) {
    GtkTextBuffer *output_buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(output_text));
    gtk_text_buffer_set_text(output_buffer, "", -1);
    append_to_notification("Salida limpiada.");
}

// Función para aumentar el zoom
void zoom_in(GtkWidget *widget, gpointer user_data) {
    PangoFontDescription *font_desc;
    font_desc = pango_font_description_from_string("Monospace 12");

    int current_size = pango_font_description_get_size(font_desc) / PANGO_SCALE;
    pango_font_description_set_size(font_desc, (current_size + 2) * PANGO_SCALE);

    gtk_widget_override_font(editor_text, font_desc);
    append_to_notification("Zoom aumentado.");
}

// Función para disminuir el zoom
void zoom_out(GtkWidget *widget, gpointer user_data) {
    PangoFontDescription *font_desc;
    font_desc = pango_font_description_from_string("Monospace 12");

    int current_size = pango_font_description_get_size(font_desc) / PANGO_SCALE;
    if (current_size > 4) {
        pango_font_description_set_size(font_desc, (current_size - 2) * PANGO_SCALE);
        gtk_widget_override_font(editor_text, font_desc);
        append_to_notification("Zoom reducido.");
    } else {
        append_to_notification("Zoom no puede reducirse más.");
    }
}
// Función para ejecutar el código
void execute_code(GtkWidget *widget, gpointer user_data) {
    GtkTextBuffer *editor_buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(editor_text));
    GtkTextIter start, end;
    gtk_text_buffer_get_start_iter(editor_buffer, &start);
    gtk_text_buffer_get_end_iter(editor_buffer, &end);
    gchar *code_text = gtk_text_buffer_get_text(editor_buffer, &start, &end, FALSE);

    gchar **lines = g_strsplit(code_text, "\n", -1);
    char output_result[4096] = "";

    for (gchar **line = lines; *line != NULL; line++) {
        gchar *trimmed_line = g_strstrip(*line);

        if (g_str_has_prefix(trimmed_line, "mostrar (")) {
            char message[256];
            if (sscanf(trimmed_line, "mostrar (\"%[^\"]\");", message) == 1) {
                strcat(output_result, message);
                strcat(output_result, "\n");
            } else {
                strcat(output_result, "Error: Sintaxis incorrecta en 'mostrar'.\n");
            }
        } else if (g_str_has_prefix(trimmed_line, "entero ")) {
            char var_name[256];
            int value;
            if (sscanf(trimmed_line, "entero %s = %d;", var_name, &value) == 2) {
                char buffer[256];
                snprintf(buffer, sizeof(buffer), "Variable '%s' asignada con valor %d.\n", var_name, value);
                strcat(output_result, buffer);
            } else {
                strcat(output_result, "Error: Sintaxis incorrecta en 'entero'.\n");
            }
        } else if (g_str_has_prefix(trimmed_line, "logico ")) {
            char var_name[256];
            char bool_value[256];
            if (sscanf(trimmed_line, "logico %s = %s;", var_name, bool_value) == 2) {
                if (strcmp(bool_value, "verdadero") == 0 || strcmp(bool_value, "falso") == 0) {
                    char buffer[256];
                    snprintf(buffer, sizeof(buffer), "Variable logica '%s' asignada con valor %s.\n", var_name, bool_value);
                    strcat(output_result, buffer);
                } else {
                    strcat(output_result, "Error: Valor incorrecto en 'logico'. Use 'verdadero' o 'falso'.\n");
                }
            } else {
                strcat(output_result, "Error: Sintaxis incorrecta en 'logico'.\n");
            }
        } else if (g_str_has_prefix(trimmed_line, "nulo ")) {
            char var_name[256];
            if (sscanf(trimmed_line, "nulo %s;", var_name) == 1) {
                char buffer[256];
                snprintf(buffer, sizeof(buffer), "Variable '%s' inicializada como nulo.\n", var_name);
                strcat(output_result, buffer);
            } else {
                strcat(output_result, "Error: Sintaxis incorrecta en 'nulo'.\n");
            }
        } else if (g_str_has_prefix(trimmed_line, "decimal ")) {
            char var_name[256];
            double value;
            if (sscanf(trimmed_line, "decimal %s = %lf;", var_name, &value) == 2) {
                char buffer[256];
                snprintf(buffer, sizeof(buffer), "Variable decimal '%s' asignada con valor %.2f.\n", var_name, value);
                strcat(output_result, buffer);
            } else {
                strcat(output_result, "Error: Sintaxis incorrecta en 'decimal'.\n");
            }
        } else if (strlen(trimmed_line) > 0) {
            strcat(output_result, "Error: Comando desconocido.\n");
        }
    }

    g_strfreev(lines);
    g_free(code_text);

    GtkTextBuffer *output_buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(output_text));
    gtk_text_buffer_set_text(output_buffer, output_result, -1);

    append_to_notification("Código ejecutado.");
}
void save_file(GtkWidget *widget, gpointer window) {
    GtkWidget *dialog = gtk_file_chooser_dialog_new("Guardar Archivo",
                                                    GTK_WINDOW(window),
                                                    GTK_FILE_CHOOSER_ACTION_SAVE,
                                                    "_Cancelar", GTK_RESPONSE_CANCEL,
                                                    "_Guardar", GTK_RESPONSE_ACCEPT,
                                                    NULL);

    if (gtk_dialog_run(GTK_DIALOG(dialog)) == GTK_RESPONSE_ACCEPT) {
        char *file_name = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(dialog));
        FILE *file = fopen(file_name, "w");

        if (file) {
            GtkTextBuffer *editor_buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(editor_text));
            GtkTextIter start, end;
            gtk_text_buffer_get_start_iter(editor_buffer, &start);
            gtk_text_buffer_get_end_iter(editor_buffer, &end);

            gchar *editor_content = gtk_text_buffer_get_text(editor_buffer, &start, &end, FALSE);
            fprintf(file, "%s", editor_content);
            fclose(file);
            g_free(editor_content);
        }
        g_free(file_name);
    }
    gtk_widget_destroy(dialog);
    append_to_notification("Archivo guardado.");
}

void open_file(GtkWidget *widget, gpointer window) {
    GtkWidget *dialog = gtk_file_chooser_dialog_new("Abrir Archivo",
                                                    GTK_WINDOW(window),
                                                    GTK_FILE_CHOOSER_ACTION_OPEN,
                                                    "_Cancelar", GTK_RESPONSE_CANCEL,
                                                    "_Abrir", GTK_RESPONSE_ACCEPT,
                                                    NULL);

    if (gtk_dialog_run(GTK_DIALOG(dialog)) == GTK_RESPONSE_ACCEPT) {
        char *file_name = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(dialog));
        FILE *file = fopen(file_name, "r");

        if (file) {
            char line[1024];
            GtkTextBuffer *editor_buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(editor_text));

            gtk_text_buffer_set_text(editor_buffer, "", -1);  // Limpiar editor antes de abrir el archivo

            while (fgets(line, sizeof(line), file)) {
                GtkTextIter end_iter;
                gtk_text_buffer_get_end_iter(editor_buffer, &end_iter);
                gtk_text_buffer_insert(editor_buffer, &end_iter, line, -1);
            }
            fclose(file);
        }
        g_free(file_name);
    }
    gtk_widget_destroy(dialog);
    append_to_notification("Archivo abierto.");
}
void show_help(GtkWidget *widget, gpointer window) {
    GtkWidget *dialog = gtk_message_dialog_new(GTK_WINDOW(window),
                                               GTK_DIALOG_MODAL,
                                               GTK_MESSAGE_INFO,
                                               GTK_BUTTONS_OK,
                                               "Comandos Disponibles:\n"
                                               "- mostrar (\"texto\"); : Muestra un mensaje.\n"
                                               "- sumar (a, b); : Suma dos números.\n"
                                               "- restar (a, b); : Resta dos números.\n"
                                               "- multiplicar (a, b); : Multiplica dos números.\n"
                                               "- dividir (a, b); : Divide dos números.\n"
                                               "- Guardar: Guarda el código en un archivo.\n"
                                               "- Abrir: Abre un archivo de código.\n");
    gtk_dialog_run(GTK_DIALOG(dialog));
    gtk_widget_destroy(dialog);
}
void activate(GtkApplication *app, gpointer user_data) {
    GtkWidget *window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), "IDE BOX 3.3");
    gtk_window_set_default_size(GTK_WINDOW(window), 1000, 700);

    GtkWidget *main_box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5);
    GtkWidget *toolbar = gtk_toolbar_new();
    GtkWidget *notebook = gtk_notebook_new();

    editor_text = gtk_text_view_new();
    gtk_text_view_set_wrap_mode(GTK_TEXT_VIEW(editor_text), GTK_WRAP_WORD);

    output_text = gtk_text_view_new();
    gtk_text_view_set_editable(GTK_TEXT_VIEW(output_text), FALSE);

    notification_bar = gtk_text_view_new();
    gtk_text_view_set_editable(GTK_TEXT_VIEW(notification_bar), FALSE);

    GtkWidget *editor_tab = gtk_scrolled_window_new(NULL, NULL);
    GtkWidget *output_tab = gtk_scrolled_window_new(NULL, NULL);
    GtkWidget *help_tab = gtk_scrolled_window_new(NULL, NULL);

    gtk_container_add(GTK_CONTAINER(editor_tab), editor_text);
    gtk_container_add(GTK_CONTAINER(output_tab), output_text);

    GtkWidget *help_label = gtk_label_new("Aquí se mostrará la ayuda interactiva.");
    gtk_container_add(GTK_CONTAINER(help_tab), help_label);

    gtk_notebook_append_page(GTK_NOTEBOOK(notebook), editor_tab, gtk_label_new("Editor"));
    gtk_notebook_append_page(GTK_NOTEBOOK(notebook), output_tab, gtk_label_new("Salida"));
    gtk_notebook_append_page(GTK_NOTEBOOK(notebook), help_tab, gtk_label_new("Ayuda"));

    // Crear menú principal
    GtkWidget *menu_bar = gtk_menu_bar_new();
    GtkWidget *file_menu_item = gtk_menu_item_new_with_label("Archivo");
    GtkWidget *file_menu = gtk_menu_new();
    GtkWidget *save_item = gtk_menu_item_new_with_label("Guardar");
    GtkWidget *open_item = gtk_menu_item_new_with_label("Abrir");

    gtk_menu_shell_append(GTK_MENU_SHELL(file_menu), open_item);
    gtk_menu_shell_append(GTK_MENU_SHELL(file_menu), save_item);
    gtk_menu_item_set_submenu(GTK_MENU_ITEM(file_menu_item), file_menu);
    gtk_menu_shell_append(GTK_MENU_SHELL(menu_bar), file_menu_item);

    g_signal_connect(save_item, "activate", G_CALLBACK(save_file), window);
    g_signal_connect(open_item, "activate", G_CALLBACK(open_file), window);

    GtkToolItem *btn_execute = gtk_tool_button_new(NULL, "Ejecutar");
    GtkToolItem *btn_clear_editor = gtk_tool_button_new(NULL, "Limpiar Editor");
    GtkToolItem *btn_clear_output = gtk_tool_button_new(NULL, "Limpiar Salida");
    GtkToolItem *btn_help = gtk_tool_button_new(NULL, "Ayuda");
    GtkToolItem *btn_zoom_in = gtk_tool_button_new(NULL, "Aumentar Zoom");
    GtkToolItem *btn_zoom_out = gtk_tool_button_new(NULL, "Reducir Zoom");

    gtk_toolbar_insert(GTK_TOOLBAR(toolbar), btn_execute, 0);
    gtk_toolbar_insert(GTK_TOOLBAR(toolbar), btn_clear_editor, 1);
    gtk_toolbar_insert(GTK_TOOLBAR(toolbar), btn_clear_output, 2);
    gtk_toolbar_insert(GTK_TOOLBAR(toolbar), btn_help, 3);
    gtk_toolbar_insert(GTK_TOOLBAR(toolbar), btn_zoom_in, 4);
    gtk_toolbar_insert(GTK_TOOLBAR(toolbar), btn_zoom_out, 5);

    g_signal_connect(btn_execute, "clicked", G_CALLBACK(execute_code), NULL);
    g_signal_connect(btn_clear_editor, "clicked", G_CALLBACK(clear_editor), NULL);
    g_signal_connect(btn_clear_output, "clicked", G_CALLBACK(clear_output), NULL);
    g_signal_connect(btn_help, "clicked", G_CALLBACK(show_help), window);
    g_signal_connect(btn_zoom_in, "clicked", G_CALLBACK(zoom_in), NULL);
    g_signal_connect(btn_zoom_out, "clicked", G_CALLBACK(zoom_out), NULL);

    gtk_box_pack_start(GTK_BOX(main_box), menu_bar, FALSE, FALSE, 0);
    gtk_box_pack_start(GTK_BOX(main_box), toolbar, FALSE, FALSE, 0);
    gtk_box_pack_start(GTK_BOX(main_box), notebook, TRUE, TRUE, 0);
    gtk_box_pack_start(GTK_BOX(main_box), notification_bar, FALSE, FALSE, 0);

    gtk_container_add(GTK_CONTAINER(window), main_box);
    gtk_widget_show_all(window);
}

int main(int argc, char *argv[]) {
    GtkApplication *app = gtk_application_new("com.ide.box", G_APPLICATION_FLAGS_NONE);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    return g_application_run(G_APPLICATION(app), argc, argv);
}
