<script lang="ts">
    import DiGithubBadge from 'svelte-icons/di/DiGithubBadge.svelte'
</script>

<div id="footer">
    <a href="https://github.com/saliougaye" target="_blank">
        <DiGithubBadge />
    </a>
    
</div>

<style>
    
    #footer {
        width: 100%;
        height: 100%;
        display: flex;
        flex-flow: row nowrap;
        justify-content: flex-end;
    }

    #footer a {
        color: #666161;
        transition: 1s;
    }

    #footer a:hover {
        color: white;
    }
    
</style>