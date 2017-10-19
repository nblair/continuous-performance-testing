package examples.app;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SampleDaoImpl implements SampleDao
{
  private final Logger logger = LoggerFactory.getLogger(SampleDaoImpl.class);
  private final AtomicLong index = new AtomicLong();
  private final Map<Long, Sample> instances = new ConcurrentHashMap<>();
  private final ObjectMapper objectMapper;
  private final String exportDirectoryPath;

  public SampleDaoImpl (final ObjectMapper objectMapper, final String exportDirectoryPath) {
    this.objectMapper = objectMapper;
    this.exportDirectoryPath = exportDirectoryPath;
  }

  @Override
  public Sample newSample(final String name) {
    Long next = index.incrementAndGet();
    Sample result = new Sample(next, name);
    instances.put(next, result);
    return result;
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

  @Override
  public void export() throws IOException {
    logger.info("exporting database to {}", exportDirectoryPath);
    objectMapper.writeValue(new File(exportDirectoryPath, "export.json"), instances);
  }
}
