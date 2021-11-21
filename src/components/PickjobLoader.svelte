<p>Pickjob:</p>
<Tile style="margin: 0  0 15px">
    {#if orderId}
        {#if pickjobsResponse?.total > 0}
            <JSONTree value="{pickjobsResponse.pickjobs[0]}"/>
        {:else}
            <Loading withOverlay={false} small/>
        {/if}
    {/if}
</Tile>

<script>
    import "carbon-components-svelte/css/white.css";
    import {Loading, Tile} from "carbon-components-svelte";
    import JSONTree from 'svelte-json-tree';

    export let orderId
    export let pickjobsResponse
</script>