/*
 * Copyright (c) 2006-2013 by Public Library of Science http://plos.org http://ambraproject.org
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.ambraproject.wombat.config;

import com.google.common.collect.ImmutableMap;
import com.google.gson.Gson;
import org.ambraproject.wombat.config.site.SiteSet;
import org.ambraproject.wombat.config.theme.Theme;
import org.ambraproject.wombat.config.theme.ThemeTree;

import java.net.URL;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Instance of {@link RuntimeConfiguration} suitable for tests.  Many of the return values here will be null or
 * meaningless defaults; we can fill them in with "real" values as tests need them.
 */
public class TestRuntimeConfiguration implements RuntimeConfiguration {

  private ImmutableMap<String, Theme> themeMap;

  /**
   * {@inheritDoc}
   */
  @Override
  public boolean devModeAssets() {
    return false;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public String getCompiledAssetDir() {
    return System.getProperty("java.io.tmpdir");
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public String getMemcachedHost() {
    return null;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public int getMemcachedPort() {
    return -1;
  }

  @Override
  public Integer getConnectionPoolMaxTotal() {
    return null;
  }

  @Override
  public Integer getConnectionPoolDefaultMaxPerRoute() {
    return null;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public String getCacheAppPrefix() {
    return "testWombat:";
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public URL getServer() {
    return null;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public URL getSolrServer() {
    return null;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public ThemeTree getThemes(Collection<? extends Theme> internalThemes, Theme rootTheme) throws ThemeTree.ThemeConfigurationException {
    Map<String, Theme> mutable = new HashMap<>();
    mutable.put("default", rootTheme);
    themeMap = ImmutableMap.copyOf(mutable);
    return new ThemeTree(themeMap);
  }

  @Override
  public SiteSet getSites(ThemeTree themeTree) {
    List<Map<String, ?>> spec = new Gson().fromJson("[ { \"key\": \"default\", \"theme\": \"default\" } ]", List.class);
    return SiteSet.create(spec, themeTree);
  }

  @Override
  public String getCasServiceUrl() {
    return null;
  }

  @Override
  public String getCasUrl() {
    return null;
  }

  @Override
  public String getCasLoginUrl() {
    return null;
  }

  @Override
  public String getCasLogoutUrl() {
    return null;
  }
}
