<script lang="ts">
	import Quote from './Quote.svelte';
	import Footer from './Footer.svelte'
</script>

<main id="body">
	<Quote />
</main>
<div id="footer">
	<Footer />
</div>


<style>
	#body {
		
		width: 100%;
		height: 95%;
	}

	#footer {
		width: 100%;
		height: 5%;
	}
</style>