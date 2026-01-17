import React, { useEffect, useRef } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X } from 'lucide-react';

/**
 * DialogModal
 * Generic modal for inputs (rename/new folder) and confirmations
 * 
 * Props:
 * - isOpen: boolean
 * - onClose: () => void
 * - title: string
 * - type: 'input' | 'confirm' | 'info'
 * - message: string
 * - initialValue: string (for input)
 * - onConfirm: (value?) => void
 * - confirmLabel: string
 * - danger: boolean (for delete)
 */
const DialogModal = ({
    isOpen,
    onClose,
    title,
    type = 'info',
    message,
    initialValue = '',
    onConfirm,
    confirmLabel = 'OK',
    danger = false
}) => {
    const inputRef = useRef(null);
    const [inputValue, setInputValue] = React.useState(initialValue);

    useEffect(() => {
        if (isOpen) {
            setInputValue(initialValue);
            // Focus input on open
            if (type === 'input') {
                setTimeout(() => inputRef.current?.focus(), 100);
            }
        }
    }, [isOpen, initialValue, type]);

    const handleConfirm = () => {
        if (type === 'input') {
            onConfirm(inputValue);
        } else {
            onConfirm();
        }
        onClose();
    };

    const handleKeyDown = (e) => {
        if (e.key === 'Enter') handleConfirm();
        if (e.key === 'Escape') onClose();
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
            <motion.div
                initial={{ opacity: 0, scale: 0.95, y: 10 }}
                animate={{ opacity: 1, scale: 1, y: 0 }}
                exit={{ opacity: 0, scale: 0.95, y: 10 }}
                className="w-full max-w-sm rounded-xl border shadow-2xl overflow-hidden"
                style={{ backgroundColor: 'var(--bg-secondary)', borderColor: 'var(--border-color)' }}
            >
                {/* Header */}
                <div className="flex items-center justify-between px-4 py-3 border-b" style={{ borderColor: 'var(--border-color)' }}>
                    <h3 className="font-semibold text-sm" style={{ color: 'var(--text-primary)' }}>{title}</h3>
                    <button onClick={onClose} className="p-1 rounded hover:bg-black/5 transition-colors">
                        <X size={16} style={{ color: 'var(--text-tertiary)' }} />
                    </button>
                </div>

                {/* Body */}
                <div className="p-4">
                    {message && (
                        <p className="text-sm mb-4" style={{ color: 'var(--text-secondary)' }}>{message}</p>
                    )}

                    {type === 'input' && (
                        <input
                            ref={inputRef}
                            type="text"
                            value={inputValue}
                            onChange={(e) => setInputValue(e.target.value)}
                            onKeyDown={handleKeyDown}
                            className="w-full px-3 py-2 rounded-lg text-sm outline-none border transition-all"
                            style={{
                                backgroundColor: 'var(--bg-primary)',
                                borderColor: 'var(--border-color)',
                                color: 'var(--text-primary)'
                            }}
                            onFocus={(e) => {
                                e.target.select();
                                e.target.style.borderColor = 'var(--accent-primary)';
                            }}
                            onBlur={(e) => e.target.style.borderColor = 'var(--border-color)'}
                        />
                    )}
                </div>

                {/* Footer */}
                <div className="flex items-center justify-end gap-2 px-4 py-3 bg-black/5">
                    <button
                        onClick={onClose}
                        className="px-3 py-1.5 rounded-lg text-sm font-medium transition-colors hover:bg-black/5"
                        style={{ color: 'var(--text-secondary)' }}
                    >
                        Cancel
                    </button>
                    <button
                        onClick={handleConfirm}
                        className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-colors text-white ${danger ? 'bg-red-500 hover:bg-red-600' : ''}`}
                        style={{ backgroundColor: danger ? undefined : 'var(--accent-primary)' }}
                    >
                        {confirmLabel}
                    </button>
                </div>
            </motion.div>
        </div>
    );
};

export default DialogModal;
