<template>
  <div
    v-if="xenApi.isPoolOverridden"
    v-tooltip="
      asTooltip && {
        placement: 'right',
        content: `
      ${$t('you-are-currently-on', [masterSessionStorage])}.
      ${$t('click-to-return-default-pool')}
      `,
      }
    "
    class="warning-not-current-pool"
    @click="xenApi.resetPoolMasterIp"
  >
    <div class="wrapper">
      <UiIcon :icon="faWarning" />
      <p v-if="!asTooltip">
        <i18n-t keypath="you-are-currently-on">
          <strong>{{ masterSessionStorage }}</strong>
        </i18n-t>
        <br />
        {{ $t('click-to-return-default-pool') }}
      </p>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { faWarning } from '@fortawesome/free-solid-svg-icons'
import { useSessionStorage } from '@vueuse/core'

import UiIcon from '@/components/ui/icon/UiIcon.vue'
import { useXenApiStore } from '@/stores/xen-api.store'
import { vTooltip } from '@/directives/tooltip.directive'

defineProps<{
  asTooltip?: boolean
}>()

const xenApi = useXenApiStore()
const masterSessionStorage = useSessionStorage('master', null)
</script>

<style lang="postcss" scoped>
.warning-not-current-pool {
  color: var(--color-orange-base);
  cursor: pointer;

  .wrapper {
    display: flex;
    justify-content: center;

    svg {
      margin: auto 1rem;
    }
  }
}
</style>
