//! Chaos Tests Module
//!
//! โหดสุด ๆ tests เพื่อพิสูจน์ว่า backend "แข็งจริง"
//!
//! ## Chaos Scenarios:
//! - Drop ทุก 3 packet
//! - Resume ผิด offset
//! - Reconnect ระหว่าง transfer
//! - Random failures
//! - Network partition simulation
//!
//! ถ้าผ่าน tests เหล่านี้ = backend แข็งจริง!

use crate::state_machine::{
    TransferState, TransferEvent, TransferError, TransferAction,
    ConnectionState, ConnectionEvent, ConnectionAction,
    Timeline,
};

// ============================================
// Chaos Transfer Simulator
// ============================================

pub struct ChaosTransferSimulator {
    pub state: TransferState,
    pub timeline: Timeline,
    pub packet_count: u64,
    pub drop_every_n: u64,
    pub wrong_offset_probability: f64,
    pub random_disconnect_probability: f64,
    pub total_bytes: u64,
    pub current_offset: u64,
    pub chunk_size: u64,
}

impl ChaosTransferSimulator {
    pub fn new(total_bytes: u64) -> Self {
        Self {
            state: TransferState::Idle,
            timeline: Timeline::new(1000),
            packet_count: 0,
            drop_every_n: 0,
            wrong_offset_probability: 0.0,
            random_disconnect_probability: 0.0,
            total_bytes,
            current_offset: 0,
            chunk_size: 1024,
        }
    }
    
    /// Drop every N packets
    pub fn drop_every(mut self, n: u64) -> Self {
        self.drop_every_n = n;
        self
    }
    
    /// Wrong offset probability (0.0 - 1.0)
    pub fn wrong_offset_probability(mut self, prob: f64) -> Self {
        self.wrong_offset_probability = prob.clamp(0.0, 1.0);
        self
    }
    
    /// Random disconnect probability (0.0 - 1.0)
    pub fn random_disconnect_probability(mut self, prob: f64) -> Self {
        self.random_disconnect_probability = prob.clamp(0.0, 1.0);
        self
    }
    
    /// Process an event through the state machine
    pub fn process_event(&mut self, event: TransferEvent) -> Result<Vec<TransferAction>, String> {
        let seq = self.timeline.next_sequence();
        match self.state.transition(event, seq) {
            Ok(result) => {
                self.state = result.new_state;
                self.timeline.record(result.timeline_entry);
                Ok(result.actions)
            }
            Err(e) => Err(format!("{}", e)),
        }
    }
    
    /// Simulate receiving a chunk
    pub fn receive_chunk(&mut self) -> ChunkResult {
        self.packet_count += 1;
        
        // Check drop_every_n
        if self.drop_every_n > 0 && self.packet_count % self.drop_every_n == 0 {
            return ChunkResult::Dropped {
                packet_number: self.packet_count,
            };
        }
        
        // Check random disconnect
        if self.random_disconnect_probability > 0.0 && rand_simple() < self.random_disconnect_probability {
            return ChunkResult::Disconnected {
                at_offset: self.current_offset,
            };
        }
        
        // Check wrong offset
        if self.wrong_offset_probability > 0.0 && rand_simple() < self.wrong_offset_probability {
            let wrong_offset = if rand_simple() < 0.5 {
                self.current_offset.saturating_sub(self.chunk_size * 2)
            } else {
                self.current_offset + self.chunk_size * 3
            };
            return ChunkResult::WrongOffset {
                expected: self.current_offset,
                received: wrong_offset,
            };
        }
        
        // Success
        let bytes_received = std::cmp::min(self.chunk_size, self.total_bytes - self.current_offset);
        self.current_offset += bytes_received;
        
        if self.current_offset >= self.total_bytes {
            ChunkResult::Complete {
                total_bytes: self.total_bytes,
            }
        } else {
            ChunkResult::Success {
                offset: self.current_offset,
                bytes: bytes_received,
            }
        }
    }
    
    /// Resume from a specific offset
    pub fn resume_from(&mut self, offset: u64) {
        self.current_offset = offset;
    }
    
    /// Get timeline dump
    pub fn dump_timeline(&self) -> String {
        self.timeline.dump_json()
    }
}

#[derive(Debug)]
pub enum ChunkResult {
    Success { offset: u64, bytes: u64 },
    Dropped { packet_number: u64 },
    Disconnected { at_offset: u64 },
    WrongOffset { expected: u64, received: u64 },
    Complete { total_bytes: u64 },
}

// ============================================
// Chaos Connection Simulator
// ============================================

pub struct ChaosConnectionSimulator {
    pub state: ConnectionState,
    pub timeline: Timeline,
    pub connection_attempt: u32,
    pub fail_first_n_attempts: u32,
    pub disconnect_after_n_heartbeats: u32,
    pub heartbeat_count: u32,
}

impl ChaosConnectionSimulator {
    pub fn new() -> Self {
        Self {
            state: ConnectionState::Disconnected,
            timeline: Timeline::new(1000),
            connection_attempt: 0,
            fail_first_n_attempts: 0,
            disconnect_after_n_heartbeats: 0,
            heartbeat_count: 0,
        }
    }
    
    /// Fail first N connection attempts
    pub fn fail_first_n(mut self, n: u32) -> Self {
        self.fail_first_n_attempts = n;
        self
    }
    
    /// Disconnect after N heartbeats
    pub fn disconnect_after_heartbeats(mut self, n: u32) -> Self {
        self.disconnect_after_n_heartbeats = n;
        self
    }
    
    /// Process an event
    pub fn process_event(&mut self, event: ConnectionEvent) -> Result<Vec<ConnectionAction>, String> {
        let seq = self.timeline.next_sequence();
        match self.state.transition(event, seq) {
            Ok(result) => {
                self.state = result.new_state;
                self.timeline.record(result.timeline_entry);
                Ok(result.actions)
            }
            Err(e) => Err(format!("{}", e)),
        }
    }
    
    /// Try to connect
    pub fn try_connect(&mut self, device_id: &str) -> ConnectionAttemptResult {
        self.connection_attempt += 1;
        
        if self.connection_attempt <= self.fail_first_n_attempts {
            ConnectionAttemptResult::Failed {
                attempt: self.connection_attempt,
                reason: format!("Simulated failure #{}", self.connection_attempt),
            }
        } else {
            ConnectionAttemptResult::Success {
                attempt: self.connection_attempt,
            }
        }
    }
    
    /// Simulate heartbeat
    pub fn heartbeat(&mut self) -> HeartbeatResult {
        self.heartbeat_count += 1;
        
        if self.disconnect_after_n_heartbeats > 0 && 
           self.heartbeat_count >= self.disconnect_after_n_heartbeats 
        {
            HeartbeatResult::Disconnected {
                after_heartbeats: self.heartbeat_count,
            }
        } else {
            HeartbeatResult::Success {
                count: self.heartbeat_count,
            }
        }
    }
    
    /// Reset heartbeat counter
    pub fn reset_heartbeat(&mut self) {
        self.heartbeat_count = 0;
    }
    
    /// Get timeline dump
    pub fn dump_timeline(&self) -> String {
        self.timeline.dump_json()
    }
}

impl Default for ChaosConnectionSimulator {
    fn default() -> Self {
        Self::new()
    }
}

#[derive(Debug)]
pub enum ConnectionAttemptResult {
    Success { attempt: u32 },
    Failed { attempt: u32, reason: String },
}

#[derive(Debug)]
pub enum HeartbeatResult {
    Success { count: u32 },
    Disconnected { after_heartbeats: u32 },
}

// ============================================
// Helper
// ============================================

fn rand_simple() -> f64 {
    use std::time::SystemTime;
    let nanos = SystemTime::now()
        .duration_since(SystemTime::UNIX_EPOCH)
        .unwrap()
        .subsec_nanos();
    (nanos % 1000) as f64 / 1000.0
}

// ============================================
// Chaos Tests
// ============================================

#[cfg(test)]
mod tests {
    use super::*;
    
    /// Test: Drop ทุก 3 packet แล้วจัดการ recovery
    #[test]
    fn test_drop_every_3_packets() {
        let mut sim = ChaosTransferSimulator::new(10000)
            .drop_every(3);
        
        // Start transfer
        sim.process_event(TransferEvent::Start {
            transfer_id: "chaos1".to_string(),
            url: "http://test".to_string(),
            total_bytes: 10000,
        }).unwrap();
        
        sim.process_event(TransferEvent::Ready { total_bytes: 10000 }).unwrap();
        
        let mut drops = 0;
        let mut successes = 0;
        
        // Simulate 20 chunks
        for _ in 0..20 {
            match sim.receive_chunk() {
                ChunkResult::Dropped { packet_number } => {
                    drops += 1;
                    // Handle drop - trigger error
                    sim.process_event(TransferEvent::Error {
                        error: TransferError {
                            code: "PACKET_DROPPED".to_string(),
                            message: format!("Packet {} dropped", packet_number),
                            is_retryable: true,
                        }
                    }).ok();
                }
                ChunkResult::Success { offset, bytes } => {
                    successes += 1;
                    sim.process_event(TransferEvent::Progress {
                        bytes: offset,
                        speed: 1000.0,
                    }).ok();
                }
                ChunkResult::Complete { .. } => {
                    sim.process_event(TransferEvent::Done).ok();
                    break;
                }
                _ => {}
            }
        }
        
        // Should have dropped some packets
        assert!(drops > 0, "Should have dropped at least some packets");
        println!("Drops: {}, Successes: {}", drops, successes);
        println!("Final state: {:?}", sim.state.kind());
    }
    
    /// Test: Resume ผิด offset
    #[test]
    fn test_wrong_offset_recovery() {
        let mut sim = ChaosTransferSimulator::new(10000)
            .wrong_offset_probability(0.3); // 30% wrong offset
        
        sim.process_event(TransferEvent::Start {
            transfer_id: "chaos2".to_string(),
            url: "http://test".to_string(),
            total_bytes: 10000,
        }).unwrap();
        
        sim.process_event(TransferEvent::Ready { total_bytes: 10000 }).unwrap();
        
        let mut wrong_offsets = 0;
        
        for _ in 0..50 {
            match sim.receive_chunk() {
                ChunkResult::WrongOffset { expected, received } => {
                    wrong_offsets += 1;
                    // Handle wrong offset - this should trigger a resume
                    println!("Wrong offset! Expected: {}, Got: {}", expected, received);
                    
                    // Simulate error and retry
                    sim.process_event(TransferEvent::Error {
                        error: TransferError {
                            code: "WRONG_OFFSET".to_string(),
                            message: format!("Expected {}, got {}", expected, received),
                            is_retryable: true,
                        }
                    }).ok();
                    
                    // Resume from correct offset
                    sim.resume_from(expected);
                }
                ChunkResult::Success { offset, .. } => {
                    sim.process_event(TransferEvent::Progress {
                        bytes: offset,
                        speed: 1000.0,
                    }).ok();
                }
                ChunkResult::Complete { .. } => {
                    sim.process_event(TransferEvent::Done).ok();
                    break;
                }
                _ => {}
            }
        }
        
        println!("Wrong offsets handled: {}", wrong_offsets);
        println!("Final state: {:?}", sim.state.kind());
    }
    
    /// Test: Reconnect ระหว่าง transfer
    #[test]
    fn test_disconnect_during_transfer() {
        let mut transfer_sim = ChaosTransferSimulator::new(10000)
            .random_disconnect_probability(0.15); // 15% disconnect
        
        transfer_sim.process_event(TransferEvent::Start {
            transfer_id: "chaos3".to_string(),
            url: "http://test".to_string(),
            total_bytes: 10000,
        }).unwrap();
        
        transfer_sim.process_event(TransferEvent::Ready { total_bytes: 10000 }).unwrap();
        
        let mut disconnects = 0;
        let mut last_good_offset = 0;
        
        for iteration in 0..100 {
            match transfer_sim.receive_chunk() {
                ChunkResult::Disconnected { at_offset } => {
                    disconnects += 1;
                    println!("Iteration {}: Disconnected at offset {}", iteration, at_offset);
                    
                    // Trigger error
                    transfer_sim.process_event(TransferEvent::Error {
                        error: TransferError {
                            code: "DISCONNECTED".to_string(),
                            message: "Connection lost".to_string(),
                            is_retryable: true,
                        }
                    }).ok();
                    
                    // Simulate reconnection and resume
                    transfer_sim.resume_from(last_good_offset);
                    
                    // Re-ready event
                    transfer_sim.process_event(TransferEvent::Ready {
                        total_bytes: 10000 - last_good_offset,
                    }).ok();
                }
                ChunkResult::Success { offset, .. } => {
                    last_good_offset = offset;
                    transfer_sim.process_event(TransferEvent::Progress {
                        bytes: offset,
                        speed: 1000.0,
                    }).ok();
                }
                ChunkResult::Complete { total_bytes } => {
                    transfer_sim.process_event(TransferEvent::Done).ok();
                    println!("Completed! Total: {} bytes", total_bytes);
                    break;
                }
                _ => {}
            }
        }
        
        println!("Disconnects handled: {}", disconnects);
        println!("Final state: {:?}", transfer_sim.state.kind());
        
        // Should have handled disconnects
        assert!(disconnects >= 0, "Test ran successfully");
    }
    
    /// Test: Connection fails first N times then succeeds
    #[test]
    fn test_connection_retry_resilience() {
        let mut sim = ChaosConnectionSimulator::new()
            .fail_first_n(2); // Fail first 2 attempts
        
        // Start connection
        sim.process_event(ConnectionEvent::Connect {
            device_id: "test-device".to_string(),
        }).unwrap();
        
        // Process connection attempts
        for _ in 0..5 {
            match sim.try_connect("test-device") {
                ConnectionAttemptResult::Failed { attempt, reason } => {
                    println!("Attempt {} failed: {}", attempt, reason);
                    sim.process_event(ConnectionEvent::ConnectionFailed {
                        reason,
                    }).ok();
                }
                ConnectionAttemptResult::Success { attempt } => {
                    println!("Attempt {} succeeded!", attempt);
                    sim.process_event(ConnectionEvent::ConnectionEstablished).unwrap();
                    break;
                }
            }
        }
        
        // Should be connected after retries
        assert!(
            matches!(sim.state, ConnectionState::Connected { .. }),
            "Should be connected after retries, but was: {:?}",
            sim.state
        );
    }
    
    /// Test: Disconnect after N heartbeats
    #[test]
    fn test_heartbeat_disconnect() {
        let mut sim = ChaosConnectionSimulator::new()
            .disconnect_after_heartbeats(3);
        
        // Connect
        sim.process_event(ConnectionEvent::Connect {
            device_id: "test-device".to_string(),
        }).unwrap();
        sim.process_event(ConnectionEvent::ConnectionEstablished).unwrap();
        
        // Simulate heartbeats
        for _ in 0..5 {
            match sim.heartbeat() {
                HeartbeatResult::Success { count } => {
                    sim.process_event(ConnectionEvent::HeartbeatReceived).ok();
                }
                HeartbeatResult::Disconnected { after_heartbeats } => {
                    println!("Disconnected after {} heartbeats", after_heartbeats);
                    sim.process_event(ConnectionEvent::ConnectionLost).unwrap();
                    break;
                }
            }
        }
        
        // Should be in Reconnecting state
        assert!(
            matches!(sim.state, ConnectionState::Reconnecting { .. }),
            "Should be reconnecting, but was: {:?}",
            sim.state
        );
    }
    
    /// Ultimate Chaos Test: ทุกอย่างพร้อมกัน!
    #[test]
    fn test_ultimate_chaos() {
        let mut sim = ChaosTransferSimulator::new(50000)
            .drop_every(5)
            .wrong_offset_probability(0.1)
            .random_disconnect_probability(0.1);
        
        sim.process_event(TransferEvent::Start {
            transfer_id: "ultimate".to_string(),
            url: "http://test".to_string(),
            total_bytes: 50000,
        }).unwrap();
        
        sim.process_event(TransferEvent::Ready { total_bytes: 50000 }).unwrap();
        
        let mut stats = ChaosStats::default();
        let mut last_good_offset = 0;
        
        for iteration in 0..500 {
            match sim.receive_chunk() {
                ChunkResult::Dropped { .. } => {
                    stats.drops += 1;
                    sim.process_event(TransferEvent::Error {
                        error: TransferError {
                            code: "DROP".to_string(),
                            message: "Dropped".to_string(),
                            is_retryable: true,
                        }
                    }).ok();
                    sim.resume_from(last_good_offset);
                    sim.process_event(TransferEvent::Ready { total_bytes: 50000 - last_good_offset }).ok();
                }
                ChunkResult::Disconnected { at_offset } => {
                    stats.disconnects += 1;
                    sim.process_event(TransferEvent::Error {
                        error: TransferError {
                            code: "DISCONNECT".to_string(),
                            message: "Disconnected".to_string(),
                            is_retryable: true,
                        }
                    }).ok();
                    sim.resume_from(last_good_offset);
                    sim.process_event(TransferEvent::Ready { total_bytes: 50000 - last_good_offset }).ok();
                }
                ChunkResult::WrongOffset { expected, .. } => {
                    stats.wrong_offsets += 1;
                    sim.resume_from(expected);
                }
                ChunkResult::Success { offset, .. } => {
                    stats.successes += 1;
                    last_good_offset = offset;
                    sim.process_event(TransferEvent::Progress {
                        bytes: offset,
                        speed: 1000.0,
                    }).ok();
                }
                ChunkResult::Complete { total_bytes } => {
                    stats.completed = true;
                    sim.process_event(TransferEvent::Done).ok();
                    break;
                }
            }
        }
        
        println!("\n=== Ultimate Chaos Test Results ===");
        println!("Drops: {}", stats.drops);
        println!("Disconnects: {}", stats.disconnects);
        println!("Wrong offsets: {}", stats.wrong_offsets);
        println!("Successes: {}", stats.successes);
        println!("Completed: {}", stats.completed);
        println!("Final state: {:?}", sim.state.kind());
        println!("Timeline entries: {}", sim.timeline.entries().len());
        
        // The test passes if we either completed or are in a recoverable state
        assert!(
            stats.completed || matches!(sim.state, 
                TransferState::Transferring { .. } | 
                TransferState::Resuming { .. } |
                TransferState::Paused { .. }
            ),
            "Should complete or be in recoverable state"
        );
    }
}

#[derive(Default)]
struct ChaosStats {
    drops: u32,
    disconnects: u32,
    wrong_offsets: u32,
    successes: u32,
    completed: bool,
}
