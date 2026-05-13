import { ExerciseComponent } from "../../comments/components/ExerciseComponent"

@Builder
export function HarmonyOSBuilder() {
  HarmonyOS()
}


@Component
struct HarmonyOS {
  @Consume("navStack") pageStack: NavPathStack

  build() {
    ExerciseComponent({text1:'鸿蒙知识点'})
  }
}