import express from "express";
import { PrismaClient } from "@prisma/client";
import cors from "cors";

const app = express();
app.use(cors());
app.use(express.json());

const prisma = new PrismaClient();

const port = 3000;

app.get("/feed", async (req, res) => {
  const feed = await prisma.post.findMany({ include: { user: true } });
  res.send(feed);
});

app.get("/@:username/:postId", async (req, res) => {
  const post = await prisma.post.findUnique({
    where: { id: Number(req.params.postId) },
  });
  if (post) {
    res.send(post);
  } else {
    res.status(404).send({ error: "Not Found" });
  }
});

app.post("/sign-up", async (req, res) => {
  const newUser = {
    fullName: req.body.fullName,
    username: req.body.username,
    email: req.body.email,
    password: req.body.password,
  };
  try {
    await prisma.user.create({ data: newUser });
    res.send({ message: "Signed up successfuly" });
  } catch (error) {
    res.status(500).send({ error });
  }
});

app.post("/new-post", async (req, res) => {
  const newPost = {
    text: req.body.text ? req.body.text : "",
    img: req.body.img ? req.body.img : "",
    user: {
      connect: {
        id: Number(req.body.id),
      },
    },
  };

  try {
    await prisma.post.create({ data: newPost });
    res.send({ message: "Post created successfully" });
  } catch (error) {
    res.status(500).send({ error });
  }
});

app.patch("/clap/:id", async (req, res) => {
  try {
    await prisma.post.update({
      where: { id: Number(req.params.id) },
      data: { claps: { increment: 1 } },
    });
    res.send({ message: "liked" });
  } catch (error) {
    res.status(404).send(error);
  }
});

app.listen(port, () => {
  console.log("Hello");
});
