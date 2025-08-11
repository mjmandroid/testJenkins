# Fake Downloader for Non-VIP Users

This implementation provides a fake download experience for non-VIP users, showing a simulated download progress at 100KB/s with random fluctuations. When the fake download reaches 80% completion, the real download begins in the background, and the remaining 20% of progress reflects the actual download progress.

## Features

- Fake download at ~100KB/s for non-VIP users
- Real download starts in background at 80% progress
- Seamless transition from fake to real downloads
- Direct real downloads for VIP users
- Mid-download VIP status detection (switches to real download)
- Progress and completion events mimic real OSS client

## Files

1. `lib/entity/task_event.dart` - Contains model classes for task progress and results
2. `lib/content/user/fake_downloader.dart` - Core fake downloader implementation
3. `lib/content/user/fake_oss_logic.dart` - Extended OssLogic using fake downloader
4. `lib/examples/fake_downloader_example.dart` - Example usage

## How to Implement

There are two implementation options:

### Option 1: Replace OssLogic (Recommended)

Replace the existing `OssLogic` implementation with `FakeOssLogic`:

```dart
// In your app bootstrap or dependency injection
void initServices() {
  // Instead of using the regular OssLogic
  // Get.put(OssLogic());
  
  // Use the fake implementation
  Get.put<OssLogic>(FakeOssLogic());
}
```

### Option 2: Direct FakeDownloader Usage

Use `FakeDownloader` directly in your download methods:

```dart
// Create a FakeDownloader instance
final fakeDownloader = FakeDownloader(client);

// Use it for downloads instead of directly using the client
String taskId = await fakeDownloader.download(
  bucketName: bucketName,
  ossFileName: ossFileName,
  filePath: filePath,
  recordFile: recordFile,
);
```

## Implementation Notes

### Core Behavior

1. For VIP users:
   - Uses the real OSS client directly
   - All progress events are passed through as-is

2. For non-VIP users:
   - Simulates download at 100KB/s with ±10KB/s random variation
   - Shows fake progress up to 80%
   - Starts real download in background when fake progress reaches 80%
   - Maps real download progress to remaining 20% (each 1% of real progress = 0.2% total progress)

3. For task cancellation:
   - Works for both fake and real downloads
   - Ensures proper cleanup of resources

### Integration with Existing Code

The implementation follows these principles:

1. **Minimal intrusion** - Direct replacement for the OSS client's download-related methods
2. **Consistent API** - Maintains the same method signatures as the original client
3. **Proper resource management** - Handles cancellation and cleanup

### Compatibility Note

The fake downloader preserves the taskId format of your application and properly maps between fake and real task IDs to ensure seamless integration with your existing progress tracking and database systems.

## Usage Example

See `lib/examples/fake_downloader_example.dart` for a complete demonstration of how to use the FakeDownloader in a UI context, including progress tracking and cancellation handling. 