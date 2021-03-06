/*
 * Copyright (c) 2017 Public Library of Science
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package org.ambraproject.wombat.config.theme;

import com.google.common.base.Charsets;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import org.yaml.snakeyaml.Yaml;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * A theme source consisting of a directory on the server's local file system.
 * <p>
 * A file named {@code sites.yaml}, at the directory's root level, defines the sites. Any file named {@code theme.yaml}
 * that appears in a subdirectory defines that subdirectory as a theme; the content of the YAML file indicates the
 * theme's key and its parents.
 */
public final class FilesystemThemeSource implements ThemeSource<FileTheme> {

  /**
   * The theme source directory, which has a {@code sites.yaml} file and whose subdirectories may be themes.
   */
  private final File directory;

  public FilesystemThemeSource(File directory) {
    Preconditions.checkArgument(directory.isDirectory());
    this.directory = directory;
  }

  private static Map<?, ?> readConfigYamlMap(File file) {
    try (Reader reader = new BufferedReader(new InputStreamReader(new FileInputStream(file), Charsets.UTF_8))) {
      return new Yaml().loadAs(reader, Map.class);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  @Override
  public List<Map<String, ?>> readSites() {
    File sitesFile = new File(directory, "sites.yaml");
    if (!sitesFile.exists()) {
      // To support multiple theme sources, of which only one has a sites.yaml file, return an empty list.
      // To check whether all sources are missing sites.yaml, we need to do it higher up.
      return ImmutableList.of();
    }

    Map<?, ?> map = readConfigYamlMap(sitesFile);
    return (List<Map<String, ?>>) map.get("sites");
  }

  /**
   * @return a collection of all {@code theme.yaml} files found in this object's directory
   */
  private Collection<File> findAllThemeFiles() throws IOException {
    Collection<File> hits = Collections.synchronizedCollection(new ArrayList<>());
    Files.walkFileTree(directory.toPath(), new SimpleFileVisitor<Path>() {
      @Override
      public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
        if (file.getFileName().toString().equalsIgnoreCase("theme.yaml")) {
          hits.add(file.toFile());
        }
        return super.visitFile(file, attrs);
      }
    });
    return hits;
  }

  private static ThemeBuilder.ConstructorFunction<FileTheme> createConstructorFunction(File themeFile) {
    File themeDirectory = Objects.requireNonNull(themeFile.getParentFile());
    return (key, parentObjects) -> new FileTheme(key, parentObjects, themeDirectory);
  }

  /**
   * @param themeFile one of the {@code theme.yaml} files found in this object's directory
   * @return a builder for the theme specified by that {@code theme.yaml} file and its subdirectory
   */
  private static ThemeBuilder<FileTheme> parseThemeDescription(File themeFile) {
    Map<?, ?> map = readConfigYamlMap(themeFile);

    String key = (String) map.get("key");
    if (key == null) {
      throw new RuntimeException("Each theme.yaml file must provide a key");
    }

    List<String> inputParentKeys = (List<String>) map.get("parents");
    List<String> parentKeys = Collections.checkedList(new ArrayList<>(), String.class);
    if (inputParentKeys != null) {
      parentKeys.addAll(inputParentKeys);
    }

    return new ThemeBuilder<>(key, parentKeys, createConstructorFunction(themeFile));
  }

  @Override
  public Collection<ThemeBuilder<FileTheme>> readThemes() {
    Collection<File> themeFiles;
    try {
      themeFiles = findAllThemeFiles();
    } catch (IOException e) {
      throw new RuntimeException(e);
    }

    return themeFiles.stream()
        .map(FilesystemThemeSource::parseThemeDescription)
        .sorted(Comparator.comparing(ThemeBuilder::getKey))
        .collect(Collectors.toList());
  }


  @Override
  public String toString() {
    return "FilesystemThemeSource{" + "directory=" + directory + '}';
  }

  @Override
  public boolean equals(Object o) {
    return this == o || o != null && getClass() == o.getClass() && directory.equals(((FilesystemThemeSource) o).directory);
  }

  @Override
  public int hashCode() {
    return directory.hashCode();
  }
}
