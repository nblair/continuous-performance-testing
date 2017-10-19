package examples.app;

import static com.google.common.base.Preconditions.checkNotNull;

public class Sample
{
  private Long id;
  private String name;

  public Sample() {
  }

  public Sample(final Long id, final String name) {
    this.id = checkNotNull(id);
    this.name = checkNotNull(name);
  }

  public Long getId() {
    return id;
  }

  public String getName() {
    return name;
  }

  public Sample setId(final Long id) {
    this.id = id;
    return this;
  }

  public Sample setName(final String name) {
    this.name = name;
    return this;
  }
}
