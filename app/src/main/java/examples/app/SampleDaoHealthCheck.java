package examples.app;

import com.codahale.metrics.health.HealthCheck;

public class SampleDaoHealthCheck extends HealthCheck
{
  private final SampleDao sampleDao;

  public SampleDaoHealthCheck(final SampleDao sampleDao) {this.sampleDao = sampleDao;}

  @Override
  protected Result check() throws Exception {
    try {
      Sample sample = sampleDao.newSample("healthcheck-" + System.currentTimeMillis());
      sampleDao.deleteSample(sample.getId());
      return Result.healthy();
    } catch (Exception e) {
      return Result.unhealthy(e);
    }
  }
}
