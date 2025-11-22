import 'dart:math';
import 'dart:core';

// 1. Merge Sort
void mergeSort(List<int> list) {
  if (list.length <= 1) return;

  int mid = list.length ~/ 2;
  List<int> left = list.sublist(0, mid);
  List<int> right = list.sublist(mid);

  mergeSort(left);
  mergeSort(right);

  _merge(list, left, right);
}

void _merge(List<int> list, List<int> left, List<int> right) {
  int i = 0, j = 0, k = 0;

  while (i < left.length && j < right.length) {
    if (left[i] <= right[j]) {
      list[k++] = left[i++];
    } else {
      list[k++] = right[j++];
    }
  }

  while (i < left.length) {
    list[k++] = left[i++];
  }

  while (j < right.length) {
    list[k++] = right[j++];
  }
}

// 2. Radix Sort
void radixSort(List<int> list) {
  if (list.length <= 1) return;

  int maxNum = list[0];
  for (int i = 1; i < list.length; i++) {
    if (list[i] > maxNum) maxNum = list[i];
  }

  int place = 1;
  while (maxNum ~/ place > 0) {
    _countingSort(list, place);
    place *= 10;
  }
}

void _countingSort(List<int> list, int place) {
  List<int> output = List.filled(list.length, 0);
  List<int> count = List.filled(10, 0);

  for (int i = 0; i < list.length; i++) {
    int digit = (list[i] ~/ place) % 10;
    count[digit]++;
  }

  for (int i = 1; i < 10; i++) {
    count[i] += count[i - 1];
  }

  for (int i = list.length - 1; i >= 0; i--) {
    int digit = (list[i] ~/ place) % 10;
    output[count[digit] - 1] = list[i];
    count[digit]--;
  }

  for (int i = 0; i < list.length; i++) {
    list[i] = output[i];
  }
}

// 3. Heap Sort
void heapSort(List<int> list) {
  int n = list.length;

  for (int i = n ~/ 2 - 1; i >= 0; i--) {
    _heapify(list, n, i);
  }

  for (int i = n - 1; i > 0; i--) {
    int temp = list[0];
    list[0] = list[i];
    list[i] = temp;

    _heapify(list, i, 0);
  }
}

void _heapify(List<int> list, int n, int i) {
  int largest = i;
  int left = 2 * i + 1;
  int right = 2 * i + 2;

  if (left < n && list[left] > list[largest]) {
    largest = left;
  }

  if (right < n && list[right] > list[largest]) {
    largest = right;
  }

  if (largest != i) {
    int swap = list[i];
    list[i] = list[largest];
    list[largest] = swap;

    _heapify(list, n, largest);
  }
}

// 4. Quick Sort
void quickSort(List<int> list) {
  _quickSortHelper(list, 0, list.length - 1);
}

void _quickSortHelper(List<int> list, int low, int high) {
  if (low < high) {
    int pi = _partition(list, low, high);

    _quickSortHelper(list, low, pi - 1);
    _quickSortHelper(list, pi + 1, high);
  }
}

int _partition(List<int> list, int low, int high) {
  int pivot = list[high];
  int i = low - 1;

  for (int j = low; j < high; j++) {
    if (list[j] <= pivot) {
      i++;
      int temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }

  int temp = list[i + 1];
  list[i + 1] = list[high];
  list[high] = temp;

  return i + 1;
}

// Check if list is sorted
bool isSorted(List<int> list) {
  for (int i = 0; i < list.length - 1; i++) {
    if (list[i] > list[i + 1]) return false;
  }
  return true;
}

void main() {
  final random = Random();
  final stopwatch = Stopwatch();
  const n = 1000000;

  print('\nSorting Algorithms Benchmark ');
  print('Testing with $n random integers\n');

  // Generate 1 million random numbers
  print('Generating $n random numbers');
  stopwatch.start();
  List<int> originalList = List.generate(n, (_) => random.nextInt(1000000));
  stopwatch.stop();
  print('Generation time: ${stopwatch.elapsedMilliseconds}ms\n');

  final algorithms = [
    ('Merge Sort', mergeSort),
    ('Radix Sort', radixSort),
    ('Heap Sort', heapSort),
    ('Quick Sort', quickSort),
  ];

  Map<String, int> results = {};

  for (var algo in algorithms) {
    String name = algo.$1;
    Function sortFunction = algo.$2;

    print('Testing $name');
    List<int> testList = List.from(originalList);

    stopwatch.reset();
    stopwatch.start();
    sortFunction(testList);
    stopwatch.stop();

    int time = stopwatch.elapsedMilliseconds;
    results[name] = time;

    print('$name completed in ${time}ms');
    print('');
  }

  print('Benchmark results: ');

  var sortedResults = results.entries.toList()
    ..sort((a, b) => a.value.compareTo(b.value));

  for (var entry in sortedResults) {
    print('${entry.key}: ${entry.value}ms');
  }

  print('\nPerformance analysis:');
  int fastest = sortedResults.first.value;
  for (var entry in sortedResults) {
    double ratio = entry.value / fastest;
    print('${entry.key}: ${ratio.toStringAsFixed(2)}x speed of fastest');
  }
}
