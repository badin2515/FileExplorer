package observability

import (
	"log/slog"
	"sync"
	"time"
)

// Metrics holds service metrics
type Metrics struct {
	mu             sync.Mutex
	requestCount   map[string]int64
	latencySum     map[string]time.Duration    // Total duration per method
	latencyBuckets map[string]map[string]int64 // Method -> Bucket -> Count
}

var (
	globalMetrics *Metrics
	metricsOnce   sync.Once
)

// GetMetrics returns global metrics instance
func GetMetrics() *Metrics {
	metricsOnce.Do(func() {
		globalMetrics = &Metrics{
			requestCount:   make(map[string]int64),
			latencySum:     make(map[string]time.Duration),
			latencyBuckets: make(map[string]map[string]int64),
		}
		// Start periodic flush
		go globalMetrics.periodicLog()
	})
	return globalMetrics
}

func (m *Metrics) periodicLog() {
	ticker := time.NewTicker(1 * time.Minute)
	for range ticker.C {
		m.LogStats()
	}
}

// RecordLatency records request latency
func (m *Metrics) RecordLatency(method string, duration time.Duration) {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.requestCount[method]++
	m.latencySum[method] += duration

	// Simple buckets: <10ms, <100ms, <500ms, <1s, >1s
	if _, ok := m.latencyBuckets[method]; !ok {
		m.latencyBuckets[method] = make(map[string]int64)
	}

	bucket := ">1s"
	if duration < 10*time.Millisecond {
		bucket = "<10ms"
	} else if duration < 100*time.Millisecond {
		bucket = "<100ms"
	} else if duration < 500*time.Millisecond {
		bucket = "<500ms"
	} else if duration < 1*time.Second {
		bucket = "<1s"
	}

	m.latencyBuckets[method][bucket]++
}

// LogStats logs current metrics snapshot
func (m *Metrics) LogStats() {
	m.mu.Lock()
	defer m.mu.Unlock()

	for method, count := range m.requestCount {
		avg := time.Duration(0)
		if count > 0 {
			avg = m.latencySum[method] / time.Duration(count)
		}

		slog.Info("Metrics Snapshot",
			"method", method,
			"count", count,
			"avg_latency", avg.String(),
			"buckets", m.latencyBuckets[method],
		)
	}
}
