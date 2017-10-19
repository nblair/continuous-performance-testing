package examples.app.resources;

import java.io.IOException;
import java.util.Collection;

import javax.inject.Singleton;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.codahale.metrics.annotation.Timed;
import examples.app.Sample;
import examples.app.SampleDao;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api("Sample API")
@Path("sample")
@Produces(MediaType.APPLICATION_JSON)
@Singleton
public class SampleResource
{
  private final SampleDao sampleDao;

  public SampleResource(final SampleDao sampleDao) {
    this.sampleDao = sampleDao;
  }

  @ApiOperation("Get a sample")
  @GET
  @Path("{id}")
  @Timed
  public Sample get(@PathParam("id") Long id) {
    return sampleDao.getSample(id);
  }

  @ApiOperation("Get all samples")
  @GET
  @Timed
  public Collection<Sample> get() {
    return sampleDao.getSamples();
  }

  @ApiOperation("Create a sample")
  @POST @Consumes(MediaType.APPLICATION_JSON)
  @Timed
  public Sample create(Sample sample) {
    return sampleDao.newSample(sample.getName());
  }

  @ApiOperation("Update a sample")
  @PUT @Consumes(MediaType.APPLICATION_JSON)
  @Path("{id}")
  @Timed
  public Sample update(@PathParam("id") Long id, Sample sample) {
    return sampleDao.updateSample(sample);
  }

  @ApiOperation("Delete a sample")
  @DELETE
  @Path("{id}")
  @Timed
  public Sample delete(@PathParam("id") Long id) {
    return sampleDao.deleteSample(id);
  }

  @ApiOperation("Export database")
  @POST
  @Path("export")
  public void export() throws IOException {
    sampleDao.export();
  }
}
