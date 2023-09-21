class Next<S, ASF, USF> {
  S? state;
  ASF? asyncSideEffect;
  USF? uiSideEffect;
  Next({this.state, this.asyncSideEffect, this.uiSideEffect});
}
