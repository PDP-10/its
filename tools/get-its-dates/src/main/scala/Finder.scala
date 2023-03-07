import java.io._
import java.nio.file._
import java.nio.file.attribute._
import java.nio.file.FileVisitResult._
import java.nio.file.FileVisitOption._
import java.nio.file.Files
import java.nio.file.FileSystems
import java.nio.file.Path
import java.nio.file.StandardCopyOption._
import scala.io.Source
import scala.language.postfixOps
import scala.util.Try
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter
import java.time.ZoneId
import java.time.LocalDateTime
import java.util.TimeZone
import java.util.Locale
import java.time.Instant
import java.util.Calendar
import java.time.ZoneOffset

class Finder(showDirs: Boolean, prefix: String) extends SimpleFileVisitor[Path] {
  val format = DateTimeFormatter.ofPattern("yyyyMMddHHmm.ss")
  val now: Calendar = Calendar.getInstance()
  val timeZone: TimeZone = now.getTimeZone()
  val cal: Calendar = Calendar.getInstance(timeZone, Locale.US)

  override def visitFile(file: Path, attrs: BasicFileAttributes): FileVisitResult = {
    if (attrs.isRegularFile) {
      val absolutePath = file.toAbsolutePath.toString
      val pathToPrint = absolutePath.replace(prefix, "")
      val attrs =  Files.readAttributes(file, classOf[BasicFileAttributes])
      val creationDate = attrs.creationTime()

      cal.setTimeInMillis(creationDate.toMillis)

      val dstOffset = cal.get(Calendar.DST_OFFSET)
      val adjustedCreationDate  = dstOffset  match {
        case 0 =>
          creationDate.toMillis()
        case 3600000 =>
          creationDate.toMillis() + dstOffset
        case _ =>
          creationDate.toMillis()
      }

      val ldt: LocalDateTime = LocalDateTime.ofEpochSecond(adjustedCreationDate / 1000, 0, ZoneOffset.ofTotalSeconds(cal.get(Calendar.ZONE_OFFSET) / 1000))
      System.out.println(s"${pathToPrint} ${ldt.format(format)}")
    }
    return CONTINUE
  }

  override def preVisitDirectory(dir: Path, attrs: BasicFileAttributes): FileVisitResult = {
    if (showDirs)
      println(s"Processing directory: ${dir.toAbsolutePath()}")
    return CONTINUE
  }

  override def visitFileFailed(file: Path, ioe: IOException): FileVisitResult = {
    System.err.println(ioe)
    return CONTINUE
  }

  def done() = {
  }
}
