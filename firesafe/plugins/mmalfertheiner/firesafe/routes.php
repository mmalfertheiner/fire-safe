<?php

Route::post('/postContact', array('as' => 'contact.post', 'uses' => 'Mmalfertheiner\Firesafe\ContactController@postContact'));