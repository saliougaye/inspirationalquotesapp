import { PrismaClient } from "@prisma/client";
import fastify from "fastify";
import { IGetQuote } from "./interfaces/IGetQuote";
import fastifyCors	 from 'fastify-cors'

const prisma = new PrismaClient();

const app = fastify({
	logger: true,
});


app.register(fastifyCors, {});

app.get<{
	Querystring: IGetQuote;
}>("/api/quote", async (req, reply) => {
	let { n } = req?.query;
	

	if (!n) {
		n = 1;
	}

	const quoteCounts = await prisma.quote.count();

	if (quoteCounts == 0) {
		return []
	}

	const quotes = [];
	let prev = -1;

	for (let i = 0; i < n; i++) {
		let skip: number;
		do {
			skip = Math.floor(Math.random() * quoteCounts);
		} while (skip == prev);

		prev = skip;

		let quote = await prisma.quote.findFirst({
			skip: skip,
		});

		quotes.push(quote);
	}

	return quotes;
});

app.listen(3000, '0.0.0.0', (err, address) => {
	if (err) {
		console.error(err);
		process.exit(0);
	}

	console.log(`Server Listening at: ${address}`);
});
