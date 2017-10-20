package example.app.simulation

import com.typesafe.config.ConfigFactory
import io.gatling.core.Predef._
import io.gatling.http.Predef.{jsonPath, _}
import org.apache.commons.lang3.RandomStringUtils
import example.app.simulation.DurationConversion.asFiniteDuration

/**
  * Gatling simulation to stress app.
  */
class SampleSimulation extends Simulation
{

  val conf = ConfigFactory.load()

  val baseUrl =
    s"${conf.getString("app.test.httpScheme")}://${conf.getString("app.test.host")}:${conf.getString("app.test.port")}"

  val httpProtocol = http
      .baseURL(baseUrl)
      .inferHtmlResources()
      .acceptHeader("*/*")
      .contentTypeHeader("application/json")
      .userAgentHeader("AppClient")

  val names = Iterator.continually {
    Map(
      "name" -> RandomStringUtils.randomAlphabetic(conf.getInt("app.test.sampleNameSize"))
    )
  }

  val scn = scenario("Sample Traffic Simulation").during(conf.getDuration("app.test.duration")) {
    feed(names).exec(
      http("POST new sample")
        .post("/sample")
        .body(StringBody("{ \"name\": \"${name}\" }"))
        .check(
          jsonPath("$.id").saveAs("id")
        )
    ).exec(
      http("GET sample by id")
        .get("/sample/${id}")
        .check(jsonPath("$.id").is("${id}"))
        .check(jsonPath("$.name").is("${name}"))
    )
  }

  setUp(scn.inject(
    rampUsers(conf.getInt("app.test.threadCount")) over (conf.getDuration("app.test.ramp"))
  )).protocols(httpProtocol)
      .assertions(global.successfulRequests.percent.gt(99))
}
