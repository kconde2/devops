<?php

namespace App\Controller;

use App\Entity\Message;
use App\Repository\MessageRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpClient\HttpClient;
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
        $output = [];
        foreach ($messages as $message) {
            $output[] = $message->getMessage();
        }
        $output = array_reverse($output);
        return $this->json($output);
    }

    /**
     * @Route("/messages", name="post_messages", methods={"POST"})
     */
    public function postMessage(Request $request, EntityManagerInterface $em)
    {
        $content = json_decode($request->getContent(), true);

        if (empty($content["message"])) {
            return new JsonResponse("Content can't be empty", 400);
        }
        $message = (new Message())->setMessage(strtoupper($content["message"]));
        $em->persist($message);
        $em->flush();
        return new JsonResponse($message->getMessage());
    }

    /**
     * @Route("/", name="index_messages", methods={"GET", "POST"})
     * @param Request $request
     * @param MessageRepository $messageRepository
     * @return Response
     */
    public function index(MessageRepository $messageRepository)
    {
        $messages = $messageRepository->findAll();
        $apiUrl = $_ENV["API_URL"];
        return $this->render('index.html.twig', [
            'api_url' => $apiUrl,
            'messages' => $messages
        ]);
    }
}
