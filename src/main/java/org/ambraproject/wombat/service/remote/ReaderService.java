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

package org.ambraproject.wombat.service.remote;

import com.google.common.base.Preconditions;
import org.apache.commons.io.Charsets;
import org.apache.http.HttpEntity;
import org.apache.http.conn.HttpClientConnectionManager;
import org.apache.http.entity.ContentType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.charset.Charset;

public class ReaderService extends AbstractRemoteService<Reader> {
  private static final Logger log = LoggerFactory.getLogger(ReaderService.class);

  public ReaderService(HttpClientConnectionManager connectionManager) {
    super(connectionManager);
  }

  /*
   * Default for converting the response's byte stream to characters.
   * Preferred over java.nio.charset.Charset.defaultCharset() to avoid an environmental dependency.
   */
  private static final Charset DEFAULT_CHARSET = Charsets.UTF_8;

  private static Charset getCharsetOrDefault(HttpEntity entity) {
    Charset charset = null;
    ContentType contentType = ContentType.get(Preconditions.checkNotNull(entity));
    if (contentType != null) {
      charset = contentType.getCharset(); // may be null
    }
    if (charset == null) {
      log.warn("Charset not specified in response header; defaulting to {}", DEFAULT_CHARSET.name());
      charset = DEFAULT_CHARSET;
    }
    return charset;
  }

  @Override
  public Reader open(HttpEntity entity) throws IOException {
    Charset charset = getCharsetOrDefault(entity);
    return new InputStreamReader(entity.getContent(), charset);
  }

}
