package examples.app;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.IsEqual.equalTo;
import static org.hamcrest.core.IsNull.notNullValue;

/**
 * Unit tests for {@link SampleDaoImpl}.
 */
public class SampleDaoImplTest
{
  private final ObjectMapper objectMapper = new ObjectMapper();

  @Rule
  public TemporaryFolder temporaryFolder = new TemporaryFolder();

  @Test
  public void successful_add_delete() {
    SampleDaoImpl sampleDao = new SampleDaoImpl(objectMapper, temporaryFolder.getRoot().getAbsolutePath());
    Sample sample = sampleDao.newSample("test");
    assertThat(sample, notNullValue());
    assertThat(sample.getName(), equalTo("test"));

    assertThat(sampleDao.deleteSample(sample.getId()), equalTo(sample));
  }
}
