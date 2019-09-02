; ModuleID = 'string.c'
source_filename = "string.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i64 @prim_fixnum_to_string(i64) #0 {
  %2 = alloca i64, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  %8 = load i8*, i8** %3, align 8
  %9 = load i64, i64* %2, align 8
  %10 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %8, i64 24, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i32 0, i32 0), i64 %9)
  %11 = load i8*, i8** %3, align 8
  %12 = getelementptr inbounds i8, i8* %11, i64 0
  %13 = bitcast i8* %12 to i64*
  %14 = load i64, i64* %13, align 8
  store i64 %14, i64* %4, align 8
  %15 = load i8*, i8** %3, align 8
  %16 = getelementptr inbounds i8, i8* %15, i64 8
  %17 = bitcast i8* %16 to i64*
  %18 = load i64, i64* %17, align 8
  store i64 %18, i64* %5, align 8
  %19 = load i8*, i8** %3, align 8
  %20 = getelementptr inbounds i8, i8* %19, i64 16
  %21 = bitcast i8* %20 to i64*
  %22 = load i64, i64* %21, align 8
  store i64 %22, i64* %6, align 8
  %23 = load i64, i64* %4, align 8
  %24 = call i32 (i64, ...) bitcast (i32 (...)* @___reserved_heap_store_i64 to i32 (i64, ...)*)(i64 %23)
  %25 = sext i32 %24 to i64
  store i64 %25, i64* %7, align 8
  %26 = load i64, i64* %5, align 8
  %27 = call i32 (i64, ...) bitcast (i32 (...)* @___reserved_heap_store_i64 to i32 (i64, ...)*)(i64 %26)
  %28 = load i64, i64* %6, align 8
  %29 = call i32 (i64, ...) bitcast (i32 (...)* @___reserved_heap_store_i64 to i32 (i64, ...)*)(i64 %28)
  %30 = load i64, i64* %7, align 8
  ret i64 %30
}

declare i32 @snprintf(i8*, i64, i8*, ...) #1

declare i32 @___reserved_heap_store_i64(...) #1

attributes #0 = { noinline nounwind optnone sspstrong uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{!"clang version 8.0.1 (tags/RELEASE_801/final)"}
