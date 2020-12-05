using Gtk;

public class MyApp : Gtk.Application {

    public MyApp() {
        Object(
                application_id: "com.github.sergejdobryak.soundy",
                flags : ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate() {
        var main_window = new Gtk.ApplicationWindow(this);
        main_window.resizable = true;
        main_window.default_height = 500;
        main_window.default_width = 500;
        main_window.window_position = WindowPosition.CENTER;
        string host = "soundtouch-speaker";
        var connection = new Connection(host, "8080");
        connection.init_ws();

        var controller = new Controller(new SoundtouchClient(connection, host));

        Model model = new Model();

        model.model_changed.connect((model) => {
            main_window.set_title(model.soundtouch_speaker_name);
        });

        main_window.add(new MainPanel(controller, model));

        main_window.show_all();
    }

    public static int main(string[] args) {
        var app = new MyApp();
        return app.run(args);
    }

}
