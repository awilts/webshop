<script>
	import JSONTree from 'svelte-json-tree';
	import { Jumper } from 'svelte-loading-spinners'
	export let objectName;
	export let isLoading;
	export let value;
</script>

<p>{objectName}:</p>
<div style="margin: 0  0 15px">
	{#if isLoading}
		<Jumper size="60" color="#FF3E00" unit="px" duration="1s"/>
	{:else if value}
		<JSONTree {value} />
	{/if}
</div>
