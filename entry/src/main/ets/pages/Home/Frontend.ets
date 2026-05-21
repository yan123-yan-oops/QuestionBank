import { ExerciseComponent } from "../../comments/components/HomeComponents/ExerciseComponent"

//导航入口
@Builder
export function FrontendBuilder() {
  Frontend()
}

@Component
struct Frontend {

  build() {
      ExerciseComponent({text1:'前端知识点'})
  }
}