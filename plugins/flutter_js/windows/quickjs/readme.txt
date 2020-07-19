Built with: gcc version 9.2.0 (Rev2, Built by MSYS2 project)

gcc -shared -static quickjs/*.c libquickjs.def -DCONFIG_VERSION=\"$(cat quickjs/VERSION)\" -o libquickjs.dll  -Wl,--out-implib,libquickjs.a -pthread -O2 -flto -s -fno-ident

Example:
cl /std:c++latest /EHsc /TP qjs.cpp /link libquickjs.a

 quickjs.h patch for MSVC:
diff --git a/quickjs/quickjs.h b/quickjs/quickjs.h
index f6494e1..d822321 100644
--- a/quickjs/quickjs.h
+++ b/quickjs/quickjs.h
@@ -53,7 +53,7 @@ typedef struct JSClass JSClass;
 typedef uint32_t JSClassID;
 typedef uint32_t JSAtom;

-#if defined(__x86_64__) || defined(__aarch64__)
+#if defined(__x86_64__) || defined(__aarch64__) || defined(_WIN64)
 #define JS_PTR64
 #define JS_PTR64_DEF(a) a
 #else
@@ -205,8 +205,13 @@ typedef struct JSValue {
 #define JS_VALUE_GET_FLOAT64(v) ((v).u.float64)
 #define JS_VALUE_GET_PTR(v) ((v).u.ptr)

+#ifdef _MSC_VER
+#define JS_MKVAL(tag, val) JSValue{ JSValueUnion{ .int32 = val }, tag }
+#define JS_MKPTR(tag, p) JSValue{ JSValueUnion{ .ptr = p }, tag }
+#else
 #define JS_MKVAL(tag, val) (JSValue){ (JSValueUnion){ .int32 = val }, tag }
 #define JS_MKPTR(tag, p) (JSValue){ (JSValueUnion){ .ptr = p }, tag }
+#endif

 #define JS_TAG_IS_FLOAT64(tag) ((unsigned)(tag) == JS_TAG_FLOAT64)

@@ -587,7 +592,7 @@ static inline JSValue JS_DupValue(JSContext *ctx, JSValueConst v)
         JSRefCountHeader *p = (JSRefCountHeader *)JS_VALUE_GET_PTR(v);
         p->ref_count++;
     }
-    return (JSValue)v;
+    return v;
 }

 static inline JSValue JS_DupValueRT(JSRuntime *rt, JSValueConst v)
@@ -596,7 +601,7 @@ static inline JSValue JS_DupValueRT(JSRuntime *rt, JSValueConst v)
         JSRefCountHeader *p = (JSRefCountHeader *)JS_VALUE_GET_PTR(v);
         p->ref_count++;
     }
-    return (JSValue)v;
+    return v;
 }

 int JS_ToBool(JSContext *ctx, JSValueConst val); /* return -1 for JS_EXCEPTION */
