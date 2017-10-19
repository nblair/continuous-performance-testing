package examples.app;

import com.fasterxml.jackson.databind.SerializationFeature;
import examples.app.resources.SampleResource;
import io.dropwizard.Application;
import io.dropwizard.configuration.ResourceConfigurationSourceProvider;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;
import io.federecio.dropwizard.swagger.SwaggerBundle;
import io.federecio.dropwizard.swagger.SwaggerBundleConfiguration;

public class EndpointApplication extends Application<EndpointConfiguration>
{

  public static void main(String[] args) throws Exception {
    new EndpointApplication().run(args);
  }

  public void run(final EndpointConfiguration endpointConfiguration, final Environment environment) throws Exception {
    environment.jersey().register(new SampleResource(sampleDao()));
  }

  @Override
  public void initialize(Bootstrap<EndpointConfiguration> bootstrap) {
    // supports loading of classpath configuration
    bootstrap.setConfigurationSourceProvider(new ResourceConfigurationSourceProvider());

    bootstrap.getObjectMapper().configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);

    bootstrap.addBundle(new SwaggerBundle<EndpointConfiguration>() {
      @Override
      protected SwaggerBundleConfiguration getSwaggerBundleConfiguration(
          EndpointConfiguration configuration) {
        return configuration.swagger;
      }
    });
  }

  protected SampleDao sampleDao() {
    return new SampleDaoImpl();
  }

}
