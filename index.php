<?php

require_once 'vendor/autoload.php';

$provider = new class implements \Limenius\ReactRenderer\Context\ContextProviderInterface {
    public function getContext($serverSide)
    {
        return [
            'serverSide' => $serverSide,
            'href' => '',
            'location' => '',
            'scheme' => '',
            'host' => '',
            'port' => '',
            'base' => '',
            'pathname' => '',
            'search' => '',
        ];
    }
};

$renderer = new \Limenius\ReactRenderer\Renderer\PhpExecJsReactRenderer(__DIR__ . '/server.js', false, $provider);
$extension = new \Limenius\ReactRenderer\Twig\ReactRenderExtension($renderer, $provider, 'server_side');

var_dump($extension->reactRenderComponentArray('Home'));
