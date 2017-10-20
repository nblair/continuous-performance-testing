package example.app.simulation

import scala.language.implicitConversions

/**
  * Scala implicit conversion from {@link java.time.Duration} to {@link scala.concurrent.duration.Duration}.
  */
object DurationConversion
{
  // this replaces the need for Duration.fromNanos(conf.getDuration("app.test.duration").toNanos)
  // conf.getDuration returns a java.time.Duration, and we need Scala Durations
  implicit def asFiniteDuration(d: java.time.Duration) = scala.concurrent.duration.Duration.fromNanos(d.toNanos)
}
