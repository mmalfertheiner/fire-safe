<?php namespace Mmalfertheiner\Firesafe;

/**
 * The plugin.php file (called the plugin initialization script) defines the plugin information class.
 */

use System\Classes\PluginBase;

class Plugin extends PluginBase
{

    public function pluginDetails()
    {
        return [
            'name'        => 'Firesafe',
            'description' => 'Provides custom features for the Firesafe website',
            'author'      => 'Malfertheiner Martin',
            'icon'        => 'icon-leaf'
        ];
    }
}
