import sys
import os
import json
import urllib.request
import subprocess
import shlex
import logging

from gi.repository import Gio
from gi.repository import GLib
from configparser import ConfigParser

BUS_NAME = 'com.kugiigi.indicator.immersive'
BUS_OBJECT_PATH = '/com/kugiigi/indicator/immersive'
BUS_OBJECT_PATH_PHONE = BUS_OBJECT_PATH + '/phone'

logger = logging.getLogger()
handler = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s %(name)-12s %(levelname)-8s %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.DEBUG)


class ImmersiveIndicator(object):
    ROOT_ACTION = 'root'
    CURRENT_ACTION = "toggle"
    SETTINGS_ACTION = 'settings'
    MAIN_SECTION = 0
    BASE_KEY = 'com.canonical.Unity8'
    
    config_file = "/home/phablet/.config/indicator-immersive/indicator-immersive.conf"  # TODO don't hardcode this
    config_object = ConfigParser()
    
    def __init__(self, bus):
        self.bus = bus
        self.action_group = Gio.SimpleActionGroup()
        self.menu = Gio.Menu()
        self.sub_menu = Gio.Menu()

        self.current_switch_icon = 'phone-smartphone-symbolic'
        
        self.settings = Gio.Settings.new(self.BASE_KEY)
        
    def get_default_edge_width(self):
        self.config_object.read(self.config_file)
        general_config = self.config_object["General"]
        return int(general_config['defaultEdgeWidth'].strip())

    def get_text(self, condition):
        text = 'Indicator Immersive'
        return text

    def get_icon(self, condition):
        icon = self.FOG
        return icon

    def toggle_mode_activated(self, action, data):
        logger.debug('toggle_mode_activated')
        edgeWidth = self.current_edgewidth()
        if edgeWidth == 0:
            self.settings.set_uint('edge-drag-width', self.get_default_edge_width())
            self.current_switch_icon = 'phone-smartphone-symbolic'
        else:
            self.settings.set_uint('edge-drag-width', 0)
            self.current_switch_icon = 'media-record'
        
        self.update_immersivemode()
        
    def settings_action_activated(self, action, data):
        logger.debug('settings_action_activated')
        subprocess.Popen(shlex.split('ubuntu-app-launch indicator-immersive.kugiigi_indicator-immersive'))


    def _setup_actions(self):
        root_action = Gio.SimpleAction.new_stateful(self.ROOT_ACTION, None, self.root_state())
        self.action_group.insert(root_action)
        
        current_action = Gio.SimpleAction.new_stateful(self.CURRENT_ACTION, None, GLib.Variant.new_boolean(self.current_state()))
        current_action.connect('activate', self.toggle_mode_activated)
        self.action_group.insert(current_action)
        
        settings_action = Gio.SimpleAction.new(self.SETTINGS_ACTION, None)
        settings_action.connect('activate', self.settings_action_activated)
        self.action_group.insert(settings_action)


    def _create_section(self):
        section = Gio.Menu()
        
        current_menu_item = Gio.MenuItem.new('Immersive mode', 'indicator.{}'.format(self.CURRENT_ACTION))
        current_menu_item.set_attribute_value('x-canonical-type', GLib.Variant.new_string('com.canonical.indicator.switch'))
        section.append_item(current_menu_item)
        
        settings_menu_item = Gio.MenuItem.new('Immersive Mode Settings', 'indicator.{}'.format(self.SETTINGS_ACTION))
        section.append_item(settings_menu_item)


        return section

    def _setup_menu(self):
        self.sub_menu.insert_section(self.MAIN_SECTION, 'Immersive', self._create_section())

        root_menu_item = Gio.MenuItem.new('Immersive', 'indicator.{}'.format(self.ROOT_ACTION))
        root_menu_item.set_attribute_value('x-canonical-type', GLib.Variant.new_string('com.canonical.indicator.root'))
        root_menu_item.set_submenu(self.sub_menu)
        self.menu.append_item(root_menu_item)

    def _update_menu(self):
        self.sub_menu.remove(self.MAIN_SECTION)
        self.sub_menu.insert_section(self.MAIN_SECTION, 'Immersive', self._create_section())

    def update_immersivemode(self): 
        logger.debug('Updated state to: {}'.format(self.current_icon()))
        self.action_group.change_action_state(self.ROOT_ACTION, self.root_state())
        self.action_group.change_action_state(self.CURRENT_ACTION, GLib.Variant.new_boolean(self.current_state()))
        self._update_menu()

    def run(self):
        self._setup_actions()
        self._setup_menu()

        self.bus.export_action_group(BUS_OBJECT_PATH, self.action_group)
        self.menu_export = self.bus.export_menu_model(BUS_OBJECT_PATH_PHONE, self.menu)

        self.update_immersivemode()

    def root_state(self):
        vardict = GLib.VariantDict.new()
        
        currentState = self.current_state()
        if currentState == True:
            vardict.insert_value('visible', GLib.Variant.new_boolean(True))
        else:
            vardict.insert_value('visible', GLib.Variant.new_boolean(False))
        
        vardict.insert_value('title', GLib.Variant.new_string('Immersive mode'))

        icon = Gio.ThemedIcon.new(self.current_icon())
        vardict.insert_value('icon', icon.serialize())

        return vardict.end()

    def current_icon(self):
        currentValue = self.current_edgewidth()
        if currentValue == 0:
            icon = 'media-record'
        else:
            icon = self.current_switch_icon
        return icon
        
    def current_edgewidth(self):
        currentValue = self.settings.get_uint("edge-drag-width")
        return currentValue
        
    def current_state(self):
        currentValue = self.current_edgewidth()
        if currentValue == 0:
            state = True
        else:
            state = False
        return state



if __name__ == '__main__':
    bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
    proxy = Gio.DBusProxy.new_sync(bus, 0, None, 'org.freedesktop.DBus', '/org/freedesktop/DBus', 'org.freedesktop.DBus', None)
    result = proxy.RequestName('(su)', BUS_NAME, 0x4)
    if result != 1:
        logger.critical('Error: Bus name is already taken')
        sys.exit(1)

    wi = ImmersiveIndicator(bus)
    wi.run()

    logger.debug('Immersive Indicator startup completed')
    GLib.MainLoop().run()
