From c306689d612124db7273ebc54287dbb93de55335 Mon Sep 17 00:00:00 2001
From: Jose Dapena Paz <jose.dapena@lge.com>
Date: Tue, 29 May 2018 17:48:45 +0000
Subject: [PATCH] GCC: include stddef for size_t definition.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

GCC build without using custom libcxx requires including stddef.h
for obtaining the declaration of size_t.

Change-Id: I4cc09a839e729cfde7bb394a7e8a27b180c20849
Reviewed-on: https://chromium-review.googlesource.com/1076469
Reviewed-by: Matthew Wolenetz <wolenetz@chromium.org>
Commit-Queue: José Dapena Paz <jose.dapena@lge.com>
Cr-Commit-Position: refs/heads/master@{#562498}
---
 media/base/subsample_entry.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/media/base/subsample_entry.h b/media/base/subsample_entry.h
index 48f8ea70b7f3f..f4117f61c5a71 100644
--- a/media/base/subsample_entry.h
+++ b/media/base/subsample_entry.h
@@ -5,6 +5,7 @@
 #ifndef MEDIA_BASE_SUBSAMPLE_ENTRY_H_
 #define MEDIA_BASE_SUBSAMPLE_ENTRY_H_
 
+#include <stddef.h>
 #include <stdint.h>
 
 #include <vector>
