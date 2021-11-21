<p>Order:</p>
<Tile style="margin: 0  0 15px">
    {#await orderPromise}
        <Loading withOverlay={false} small/>
    {:then order}
        {#if order}
            <JSONTree value="{order}"/>
        {/if}
    {/await}
</Tile>

<script>
    import "carbon-components-svelte/css/white.css";
    import {Loading, Tile} from "carbon-components-svelte";
    import JSONTree from 'svelte-json-tree';

    export let orderPromise
</script>