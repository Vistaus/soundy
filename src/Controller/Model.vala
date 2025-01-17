/* Copyright 2021 Sergej Dobryak <sergej.dobryak@gmail.com>
*
* This program is free software: you can redistribute it
* and/or modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with this program. If not, see http://www.gnu.org/licenses/.
*/

public class Model : GLib.Object {

    public signal void model_changed(Model model);

    public bool connection_established {get;set;default=false;}
    public bool connection_dialog_tried {get;set;default=false;}

    public uint8 actual_volume {get;set;}
    public uint8 target_volume {get;set;}
    public bool mute_enabled {get;set;default=false;}

    public bool is_radio_streaming {get;set;default=false;}
    public bool is_buffering_in_progress {get;set;default=false;}

    public bool is_standby {get;set;default=false;}

    bool _is_playing = false;
    public bool is_playing {
        get {
            return _is_playing;
        }
        set {
            _is_playing = value;
        }
    }

    string _soundtouch_speaker_name = "";
    public string soundtouch_speaker_name {
        get {
            return _soundtouch_speaker_name;
        }
        set {
            _soundtouch_speaker_name = value;
        }
    }
    string _track = "";
    public string track {
        get {
            return _track;
        }
        set {
            _track = value;
        }
    }
    string _artist = "";
    public string artist {
        get {
            return _artist;
        }
        set {
            _artist = value;
        }
    }
    string _image_url = "";
    public string image_url {
        get {
            return _image_url;
        }
        set {
            _image_url = value;
        }
    }

    public void fire_changed() {
        this.model_changed(this);
    }
}
