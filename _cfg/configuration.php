<?php
$cfg = new \diCore\Data\Configuration();
$cfg->setTabsAr([
    'general' => 'Основное',
    'pics' => 'Картинки',
    'counts' => 'Отображение',
])
    ->setInitialData([
        'auto_save_timeout' => [
            'title' => 'Период автосохранения, сек',
            'type' => 'int',

            'value' => 0,
            'notes' => [
                'Автосохранение работает в каждой форме Админки. Если 0, то автосохранение отключено',
            ],
        ],

        'open_graph_default_pic' => [
            'title' => 'Картинка Open graph по умолчанию',
            'type' => 'pic',
            'value' => '',
            'tab' => 'pics',
        ],

        'sample_width' => [
            'title' => 'Ширина изображений',
            'type' => 'int',
            'value' => 1920,
            'tab' => 'pics',
        ],

        'sample_height' => [
            'title' => 'Высота изображений',
            'type' => 'int',
            'value' => 1080,
            'tab' => 'pics',
        ],

        'sample_tn_width' => [
            'title' => 'Ширина превью изображений',
            'type' => 'int',
            'value' => 400,
            'tab' => 'pics',
        ],

        'sample_tn_height' => [
            'title' => 'Высота превью изображений',
            'type' => 'int',
            'value' => 200,
            'tab' => 'pics',
        ],

        'admin_per_page[admins]' => [
            'title' => 'Админов на странице (в админке)',
            'type' => 'int',
            'value' => 30,
            'tab' => 'counts',
        ],

        'admin_per_page[mail_queue]' => [
            'title' => 'Писем в очереди на странице (в админке)',
            'type' => 'int',
            'value' => 30,
            'tab' => 'counts',
        ],

        'sender_email' => [
            'title' => 'E-mail для исходящих писем',
            'type' => 'string',
            'value' => 'noreply@' . \diCore\Data\Config::getMainDomain(),
            'tab' => 'general',
        ],
    ])
    ->loadCache();
