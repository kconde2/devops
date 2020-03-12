<?php

namespace App\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class MessageControllerTest extends WebTestCase
{
    public function testGetMessage()
    {
        $client = static::createClient();

        $client->request('GET', '/messages');

        $this->assertEquals(200, $client->getResponse()->getStatusCode());
    }

    public function testPostMessage()
    {
        $client = static::createClient();
        $string = "Testing the POST endpoint";

        $client->request('POST', '/messages', ['content' => $string]);

        $responseData = json_decode($client->getResponse()->getContent(), true);
        
        $this->assertEquals(
            strtoupper($string),
            $responseData
        );
    }
    public function testPostEmptyMessage()
    {
        $client = static::createClient();
        $emptyString = "";

        $client->request('POST', '/messages', ['content' => $emptyString]);
        
        $this->assertEquals(400, $client->getResponse()->getStatusCode());
    }
}
