<script lang="ts">
    import { IQuote } from './types/IQuote';
    import { Firework } from 'svelte-loading-spinners'


    const fetchQuote = ( async () : Promise<IQuote[]> => {
        const response = await fetch('http://localhost:3000/api/quote');

        return await response.json()
    })()
</script>

<main id="quote">
    {#await fetchQuote}
    <div>
        <Firework 
            color="#FFFFFF"
            duration='2s'
            size="100"
            unit="px"

        />
    </div>
    {:then data} 
    <div id="quote-box">
        <div class="quote">
            <p>{data[0].quote}</p>
        </div>
        <div class="author">
            <p>{data[0].author}</p>
        </div>
    </div>
    {:catch error}
        <div id="error">
            <p>Error occured on fetch</p>
            <pre>{error}</pre>
        </div>
    {/await}
</main>

<style>
    @import url('https://fonts.googleapis.com/css2?family=Amatic+SC:wght@700&display=swap');

    #quote {
        width: 100%;
        height: 100%;
        display: flex;
        flex-flow: row nowrap;
        justify-content: center;
        align-items: center;
    }
    #quote p {
        color: white;
        font-family: 'lisFont', 'Amatic SC', 'Dongle',sans-serif;
    }

    #quote-box {
        width: 90%;
        display: flex;
        flex-flow: column nowrap;
    }

    #quote-box .quote {
        width: 100%;
        text-align: center;
    }

    #quote-box .quote p {
        font-size: 36px;
    }

    #quote-box .author {
        width: 100%;
        text-align: end;
    }
    #quote-box .author p {
        font-size: 28px;
    }


</style>
