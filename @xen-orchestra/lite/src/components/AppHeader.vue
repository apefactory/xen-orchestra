<template>
  <header class="app-header">
    <UiIcon v-if="isMobile" ref="navigationTrigger" :icon="faBars" class="toggle-navigation" />
    <RouterLink :to="{ name: 'home' }">
      <img v-if="isMobile" alt="XO Lite" src="../assets/logo.svg" />
      <TextLogo v-else />
    </RouterLink>
    <slot />
    <div class="right">
      <PoolOverrideWarning as-tooltip />
      <UiButton v-if="isDesktop" :icon="faDownload" @click="openXoaDeploy">
        {{ $t('deploy-xoa') }}
      </UiButton>
      <AccountButton />
    </div>
  </header>
</template>

<script lang="ts" setup>
import AccountButton from '@/components/AccountButton.vue'
import PoolOverrideWarning from '@/components/PoolOverrideWarning.vue'
import TextLogo from '@/components/TextLogo.vue'
import UiButton from '@/components/ui/UiButton.vue'
import UiIcon from '@/components/ui/icon/UiIcon.vue'
import { useNavigationStore } from '@/stores/navigation.store'
import { useRouter } from 'vue-router'
import { useUiStore } from '@/stores/ui.store'
import { faBars, faDownload } from '@fortawesome/free-solid-svg-icons'
import { storeToRefs } from 'pinia'

const router = useRouter()

const openXoaDeploy = () => router.push({ name: 'xoa.deploy' })

const uiStore = useUiStore()
const { isMobile, isDesktop } = storeToRefs(uiStore)

const navigationStore = useNavigationStore()
const { trigger: navigationTrigger } = storeToRefs(navigationStore)
</script>

<style lang="postcss" scoped>
.app-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 5.5rem;
  padding: 1rem;
  border-bottom: 0.1rem solid var(--color-grey-500);
  background-color: var(--background-color-secondary);

  img {
    width: 4rem;
  }

  .text-logo {
    margin-left: 1rem;
    vertical-align: middle;
  }

  .warning-not-current-pool {
    font-size: 2.4rem;
  }
}

.right {
  display: flex;
  align-items: center;
  gap: 2rem;
}
</style>
