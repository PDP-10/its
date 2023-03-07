import java.nio.file._

object GetItsDates extends App {
  if (this.args.size != 2) {
    println(s"Syntax is:")
    println(s"  get-its-datess <root directory> <prefix>")
  }
  else {
    val rootDir = this.args(0)
    val prefix = this.args(1)
    val finder = new Finder(false, prefix)
    Files.walkFileTree(
      Paths.get(rootDir),
      finder
    )
    finder.done()
  }
}
