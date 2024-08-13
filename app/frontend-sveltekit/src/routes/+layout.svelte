<main>
    <header>
        <nav class="bg-black text-white px-4 py-4 flex items-center">
            <h1 class="text-xl uppercase tracking-tight font-medium">
                <a href="/">
                    APP
                </a>
            </h1>
            <a class="text-sm hover:text-gray-200 font-light hover:underline ml-7 " href="/orders/new">
                Orderレコードの作成 →
            </a>
        </nav>
    </header>
    <slot />
</main>

<script lang="ts">
  import "../app.css";
</script>