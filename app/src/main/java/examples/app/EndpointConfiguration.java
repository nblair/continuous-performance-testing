package examples.app;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.dropwizard.Configuration;
import io.federecio.dropwizard.swagger.SwaggerBundleConfiguration;

public class EndpointConfiguration extends Configuration
{
  @JsonProperty("swagger")
  public SwaggerBundleConfiguration swagger;

  @JsonProperty("exportDirectory")
  public String exportDirectoryPath = System.getProperty("java.io.tmpdir");
}
