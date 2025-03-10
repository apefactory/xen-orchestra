<template>
  <slot :is-open="isOpen" :open name="trigger" />
  <Teleport to="body" :disabled="!shouldTeleport">
    <ul v-if="!hasTrigger || isOpen" ref="menu" :class="{ horizontal, shadow }" class="app-menu" v-bind="$attrs">
      <slot />
    </ul>
  </Teleport>
</template>

<script lang="ts" setup>
import { useContext } from '@/composables/context.composable'
import { DisabledContext } from '@/context'
import { IK_CLOSE_MENU, IK_MENU_HORIZONTAL, IK_MENU_TELEPORTED } from '@/types/injection-keys'
import placementJs, { type Options } from 'placement.js'
import { computed, inject, nextTick, provide, ref, useSlots } from 'vue'
import { onClickOutside, unrefElement, whenever } from '@vueuse/core'

const props = withDefaults(
  defineProps<{
    horizontal?: boolean
    shadow?: boolean
    disabled?: boolean
    placement?: Options['placement']
  }>(),
  { disabled: undefined }
)

defineOptions({
  inheritAttrs: false,
})

const slots = useSlots()
const isOpen = ref(false)
const menu = ref()
const isParentHorizontal = inject(
  IK_MENU_HORIZONTAL,
  computed(() => false)
)
provide(
  IK_MENU_HORIZONTAL,
  computed(() => props.horizontal ?? false)
)

useContext(DisabledContext, () => props.disabled)

let clearClickOutsideEvent: (() => void) | undefined

const hasTrigger = useSlots().trigger !== undefined

const shouldTeleport = hasTrigger && !inject(IK_MENU_TELEPORTED, false)

if (shouldTeleport) {
  provide(IK_MENU_TELEPORTED, true)
}

whenever(
  () => !isOpen.value,
  () => clearClickOutsideEvent?.()
)
if (slots.trigger && inject(IK_CLOSE_MENU, undefined) === undefined) {
  provide(IK_CLOSE_MENU, () => (isOpen.value = false))
}

const open = (event: MouseEvent) => {
  if (isOpen.value) {
    return (isOpen.value = false)
  }

  isOpen.value = true

  nextTick(() => {
    clearClickOutsideEvent = onClickOutside(menu, () => (isOpen.value = false), {
      ignore: [event.currentTarget as HTMLElement],
    })

    placementJs(event.currentTarget as HTMLElement, unrefElement(menu), {
      placement: props.placement ?? (isParentHorizontal.value ? 'bottom-start' : 'right-start'),
    })
  })
}
</script>

<style lang="postcss" scoped>
.app-menu {
  z-index: 1;
  display: inline-flex;
  flex-direction: column;
  padding: 0.5rem;
  cursor: default;
  color: var(--color-grey-200);
  border-radius: 0.8rem;
  background-color: var(--color-grey-600);
  gap: 0.5rem;

  &.horizontal {
    flex-direction: row;
  }

  &.shadow {
    box-shadow: var(--shadow-300);
  }
}
</style>
