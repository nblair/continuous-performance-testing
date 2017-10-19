package examples.app;

import java.util.Collection;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

public class SampleDaoImpl implements SampleDao
{
  private final AtomicLong index = new AtomicLong();
  private final Map<Long, Sample> instances = new ConcurrentHashMap<>();

  @Override
  public Sample newSample(final String name) {
    Long next = index.incrementAndGet();
    return instances.put(next, new Sample(next, name));
  }

  @Override
  public Sample updateSample(final Sample sample) {
    instances.put(sample.getId(), sample);
    return sample;
  }

  @Override
  public Sample getSample(final Long id) {
    return instances.get(id);
  }

  @Override
  public Sample deleteSample(final Long id) {
    return instances.remove(id);
  }

  @Override
  public Collection<Sample> getSamples() {
    return instances.values();
  }
}
