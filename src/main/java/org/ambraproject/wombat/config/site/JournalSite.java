package org.ambraproject.wombat.config.site;

import org.ambraproject.wombat.config.site.url.SiteRequestScheme;
import org.ambraproject.wombat.config.theme.Theme;

import java.util.Objects;

public class JournalSite extends Site {

  private final String journalKey;
  private final String journalName;

  JournalSite(String key, Theme theme, SiteRequestScheme requestScheme, String journalKey, String journalName) {
    super(key, theme, requestScheme);
    this.journalKey = Objects.requireNonNull(journalKey);
    this.journalName = Objects.requireNonNull(journalName);
  }

  public String getJournalKey() {
    return journalKey;
  }

  public String getJournalName() {
    return journalName;
  }

  @Override
  public boolean isJournalSpecific() {
    return true;
  }

}