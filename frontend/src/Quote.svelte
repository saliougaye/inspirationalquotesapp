<script lang="ts">
    import { IQuote } from './types/IQuote';
    import { Firework } from 'svelte-loading-spinners';
    import Typewriter from 'svelte-typewriter';
    
    const API_URL = process['env']['API'];
    const fetchQuote = ( async () : Promise<IQuote[]> => {
        const response = await fetch(API_URL);

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
        <Typewriter cascade interval={30}>

            <div class="quote">
                <p>{data[0].quote}</p>
            </div>
            <div class="author">
                <p>{data[0].author}</p>
            </div>
        </Typewriter> 
    </div>
    
    {:catch error}
    
    <div id="error">
        <Typewriter cascade interval={30}>
            <div class="text-error">
                <p>Everyone is wrong, especially me. there is something wrong, sorry</p>
            </div>
            
            <div class="author-error">
                <p>Me</p>
            </div>>
        </Typewriter>
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
    #quote p,
    #error p {
        color: white;
        font-family: 'lisFont', 'Amatic SC', 'Dongle',sans-serif;
    }

    #quote-box,
    #error {
        width: 90%;
        display: flex;
        flex-flow: column nowrap;
    }

    #quote-box .quote,
    #error .text-error {
        width: 100%;
        text-align: center;
    }

    #quote-box .quote p,
    #error .text-error p {
        font-size: 36px;
    }

    #quote-box .author,
    #error .author-error {
        width: 100%;
        text-align: end;
    }
    #quote-box .author p,
    #error .author-error p {
        font-size: 28px;
    }


</style>
