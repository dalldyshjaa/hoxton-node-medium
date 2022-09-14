/*
  Warnings:

  - You are about to drop the column `claps` on the `Post` table. All the data in the column will be lost.
  - You are about to drop the column `comments` on the `Post` table. All the data in the column will be lost.

*/
-- CreateTable
CREATE TABLE "Comment" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "comment_text" TEXT NOT NULL,
    "userID" INTEGER NOT NULL,
    "postID" INTEGER NOT NULL,
    CONSTRAINT "Comment_userID_fkey" FOREIGN KEY ("userID") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Comment_postID_fkey" FOREIGN KEY ("postID") REFERENCES "Post" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Clap" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "clap_nr" INTEGER NOT NULL,
    "userID" INTEGER NOT NULL,
    "postID" INTEGER NOT NULL,
    CONSTRAINT "Clap_userID_fkey" FOREIGN KEY ("userID") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Clap_postID_fkey" FOREIGN KEY ("postID") REFERENCES "Post" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Post" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "text" TEXT,
    "img" TEXT,
    "claps_nr" INTEGER NOT NULL DEFAULT 0,
    "comments_nr" INTEGER NOT NULL DEFAULT 0,
    "userID" INTEGER NOT NULL,
    CONSTRAINT "Post_userID_fkey" FOREIGN KEY ("userID") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Post" ("id", "img", "text", "userID") SELECT "id", "img", "text", "userID" FROM "Post";
DROP TABLE "Post";
ALTER TABLE "new_Post" RENAME TO "Post";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
