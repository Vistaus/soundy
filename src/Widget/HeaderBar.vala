namespace Soundy {
    public class HeaderBar : Gtk.HeaderBar {

        private Gtk.Label title;
        private Gtk.Button power_on_off;
        private Gtk.VolumeButton volume_button;
        private Gtk.MenuButton favourites;
        private Gtk.MenuButton settings;
        private Gtk.Box main_box;

        public HeaderBar(Controller controller, Model model) {
            set_show_close_button(true);
            title = new Gtk.Label("No title");

            model.model_changed.connect((model) => {
                this.update_gui(model);
            });

            power_on_off = create_button("system-shutdown-symbolic", 16);
            power_on_off.clicked.connect((event) => {
                controller.power_on_clicked();
            });


            volume_button = new Gtk.VolumeButton();
            volume_button.use_symbolic = true;
            volume_button.adjustment = new Gtk.Adjustment(0.0, 0.0, 100.0, 5.0, 5.0, 5.0);
            volume_button.value_changed.connect((value) => {
                controller.update_volume((uint8)(value));
                message("value changed: " + value.to_string());
            });

            favourites = this.create_menu_button("non-starred-symbolic", 16);
            this.create_preset_items(controller);

            settings = this.create_menu_button("preferences-system-symbolic", 16);
            this.create_settings_items();

            main_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);
            main_box.halign = Gtk.Align.CENTER;

            main_box.pack_start(title);
            main_box.pack_start(power_on_off);

            pack_end(settings);
            pack_end(favourites);
            pack_end(volume_button);

            custom_title = main_box;
        }

        public void update_title(string soundtouch_speaker_name) {
            title.set_text(soundtouch_speaker_name);
        }

        private Gtk.Button create_button(string icon, int size) {
            var button = new Gtk.Button();

            var menu_icon = new Gtk.Image();
            menu_icon.gicon = new ThemedIcon(icon);
            menu_icon.pixel_size = size;

            button.get_style_context().add_class(Gtk.STYLE_CLASS_FLAT);
            button.image = menu_icon;
            button.can_focus = false;
            return button;
        }

        public void create_preset_items(Controller controller) {

            var menu_grid = new Gtk.Grid();
            menu_grid.margin_top = 6;
            menu_grid.margin_bottom = 6;
            menu_grid.orientation = Gtk.Orientation.VERTICAL;


            PresetsMessage presets = controller.get_presets();
            foreach(Preset p in presets.get_presets()){
                message(p.item_image_url);
                var item = new FavouriteMenuItem(p, p.item_image_url, controller);
                menu_grid.add(item);
            }

            menu_grid.show_all();

            var popover = new Gtk.Popover(null);
            popover.add(menu_grid);
            favourites.popover = popover;
        }

        public void update_gui(Model model) {
            if (!model.connection_established) {
                update_title("No connection");
                power_on_off.visible = false;
            } else {
                update_title(model.soundtouch_speaker_name);
                power_on_off.visible = true;
            }


            if (model.mute_enabled) {
                message("mute");
                this.volume_button.set_value(0);
            } else {
                message("current volume: " + model.actual_volume.to_string());
                double actual_volume = (double) model.actual_volume;
                this.volume_button.set_value(actual_volume);
            }
        }


        public Gtk.MenuButton create_menu_button(string icon_name, int pixel_size) {
            var menu_button = new Gtk.MenuButton();
            var menu_icon = new Gtk.Image();
            menu_icon.gicon = new ThemedIcon(icon_name);
            menu_icon.pixel_size = pixel_size;

            menu_button.get_style_context().add_class(Gtk.STYLE_CLASS_FLAT);
            menu_button.image = menu_icon;
            menu_button.can_focus = false;
            return menu_button;
        }


        public void create_settings_items() {
            var menu_grid = new Gtk.Grid();
            menu_grid.margin_top = 6;
            menu_grid.margin_bottom = 6;
            menu_grid.orientation = Gtk.Orientation.VERTICAL;

            var wifi_button = new Gtk.Button.with_label("Wifi signal");
            wifi_button.can_focus = false;
            wifi_button.get_style_context().add_class(Gtk.STYLE_CLASS_MENUITEM);
            wifi_button.get_style_context().add_class(Gtk.STYLE_CLASS_FLAT);

            var speaker_host_button = new Gtk.Button.with_label("Speaker host");
            speaker_host_button.can_focus = false;
            speaker_host_button.get_style_context().add_class(Gtk.STYLE_CLASS_MENUITEM);
            speaker_host_button.get_style_context().add_class(Gtk.STYLE_CLASS_FLAT);


            var about_button = new Gtk.Button.with_label("About");
            about_button.can_focus = false;
            about_button.get_style_context().add_class(Gtk.STYLE_CLASS_MENUITEM);
            about_button.get_style_context().add_class(Gtk.STYLE_CLASS_FLAT);

            menu_grid.add(wifi_button);
            menu_grid.add(new Gtk.Separator(Gtk.Orientation.HORIZONTAL));
            menu_grid.add(speaker_host_button);
            menu_grid.add(about_button);
            menu_grid.show_all();

            var popover = new Gtk.Popover(null);
            popover.add(menu_grid);
            settings.popover = popover;
        }
    }
}