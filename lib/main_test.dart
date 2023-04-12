void main() {
  //A day on earth is a 1000 years to god
  //Determine what a earth second is to god?

  const int secondsInADay = 24 * 60 * 60;

  const int secondsInAyear = 365 * secondsInADay;

  calcGodSeconds() {
    // 1dday ---> 1000 years
    // 1 second --> ????

    // secondsInaday ---> secondsInAyear * 1000;
    // 1 second ---- ??

    return (secondsInAyear * 1000) / secondsInADay;
  }

  print(calcGodSeconds());
}
