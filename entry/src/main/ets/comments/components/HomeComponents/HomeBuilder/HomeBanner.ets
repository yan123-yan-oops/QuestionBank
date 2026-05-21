@Component
export struct HomeBanner {
  @Prop bannerList: Resource[]

  build() {

      Swiper() {
        ForEach(this.bannerList, (item: Resource) => {
          Image(item)
            .width(360)
            .borderRadius(14)
            .margin({ top: 18 })

        })
      }
      .loop(true)
      .autoPlay(true)
      .indicator(true)
      .height(180)
      .padding({ top: 12 })
    }

}
