import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  // Connect the client
  await prisma.$connect()
  // ... you will write your Prisma Client queries here


  const allQuotes = await prisma.quote.findMany({
      take: 10
  });

  console.log(allQuotes)
}

main()
  .catch((e) => {
    throw e
  })
  .finally(async () => {
    await prisma.$disconnect()
  })