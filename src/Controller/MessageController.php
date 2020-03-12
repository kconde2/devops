<?php

namespace App\Controller;

use App\Entity\Message;
use App\Repository\MessageRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\SerializerInterface;

class MessageController extends AbstractController
{
    /**
     * @Route("/messages", name="get_messages", methods={"GET"})
     */
    public function getMessage(MessageRepository $messageRepository, SerializerInterface $serializer)
    {
        $messages = $messageRepository->findAll();
        $messages = $serializer->serialize($messages, 'json');
        return new Response($messages);
    }

    /**
     * @Route("/messages", name="post_messages", methods={"POST"})
     */
    public function postMessage(Request $request, EntityManagerInterface $em)
    {
        $content = $request->request->get('content', '');
        if (empty($content)) {
            return new JsonResponse("Content can't be empty", 400);
        }
        $message = (new Message())->setContent($content);
        $em->persist($message);
        $em->flush();
        return new JsonResponse('Message saved');
    }

    /**
     * @Route("/", name="index_messages", methods={"GET", "POST"})
     */
    public function index(Request $request, MessageRepository $messageRepository)
    {
        $messages = $messageRepository->findAll();
        $apiUrl = $_ENV["API_URL"];
        return $this->render('index.html.twig', [
            'api_url' => $apiUrl,
            'messages' => $messages
        ]);
    }
}
