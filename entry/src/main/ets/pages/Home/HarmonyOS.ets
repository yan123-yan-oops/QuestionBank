import { ExerciseComponent } from "../../comments/components/ExerciseComponent"

@Builder
export function HarmonyOSBuilder() {
  HarmonyOS()
}

@Component
struct HarmonyOS {
  build() {
    ExerciseComponent({text1:'鸿蒙知识点'})
  }
}