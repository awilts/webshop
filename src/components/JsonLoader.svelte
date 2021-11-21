<p>{objectName}:</p>
<Tile style="margin: 0  0 15px">
    {#if isLoading}
        <Loading withOverlay={false} small/>
    {:else if value}
        <JSONTree value="{value}"/>
    {/if}
</Tile>

<script>
    import {Loading, Tile} from "carbon-components-svelte";
    import JSONTree from 'svelte-json-tree';

    export let objectName
    export let isLoading
    export let value
</script>