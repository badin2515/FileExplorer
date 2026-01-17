import React, { useEffect, useRef } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

/**
 * Context Menu Component
 * 
 * Props:
 * - position: { x, y } | null
 * - items: Array<{ id, label, icon, shortcut, onClick, danger, disabled, separator }>
 * - onClose: () => void
 */
const ContextMenu = ({ position, items, onClose }) => {
    const menuRef = useRef(null);

    // Close when clicking outside
    useEffect(() => {
        const handleClick = (e) => {
            if (menuRef.current && !menuRef.current.contains(e.target)) {
                onClose();
            }
        };

        // Close on escape key
        const handleKeyDown = (e) => {
            if (e.key === 'Escape') onClose();
        };

        if (position) {
            document.addEventListener('mousedown', handleClick);
            document.addEventListener('keydown', handleKeyDown);
            // Disable default browser context menu inside our menu
            menuRef.current?.addEventListener('contextmenu', (e) => e.preventDefault());
        }

        return () => {
            document.removeEventListener('mousedown', handleClick);
            document.removeEventListener('keydown', handleKeyDown);
        };
    }, [position, onClose]);

    // Prevent menu from going off-screen (basic logic)
    // In a real app, use a library like 'floating-ui' for better positioning
    const x = position?.x;
    const y = position?.y;

    if (!position) return null;

    return (
        <AnimatePresence>
            <motion.div
                ref={menuRef}
                initial={{ opacity: 0, scale: 0.95 }}
                animate={{ opacity: 1, scale: 1 }}
                exit={{ opacity: 0, scale: 0.95 }}
                transition={{ duration: 0.1 }}
                className="fixed z-50 min-w-[200px] rounded-lg shadow-xl backdrop-blur-lg overflow-hidden border"
                style={{
                    top: y,
                    left: x,
                    backgroundColor: 'var(--bg-secondary)', // opaque enough
                    borderColor: 'var(--border-color)',
                    boxShadow: '0 4px 20px rgba(0,0,0,0.15)'
                }}
            >
                <div className="py-1">
                    {items.map((item, index) => {
                        if (item.separator) {
                            return (
                                <div
                                    key={`sep-${index}`}
                                    className="my-1 h-px bg-current opacity-10"
                                />
                            );
                        }

                        if (!item.label) return null;

                        return (
                            <button
                                key={item.id || index}
                                onClick={(e) => {
                                    e.stopPropagation();
                                    if (!item.disabled) {
                                        item.onClick();
                                        onClose();
                                    }
                                }}
                                disabled={item.disabled}
                                className={`
                                    w-full px-3 py-1.5 flex items-center justify-between text-left text-sm transition-colors
                                    ${item.disabled ? 'opacity-50 cursor-not-allowed' : 'hover:bg-[var(--bg-hover)] cursor-pointer'}
                                    ${item.danger ? 'text-red-500' : 'text-[var(--text-primary)]'}
                                `}
                            >
                                <div className="flex items-center gap-2">
                                    {item.icon && <item.icon size={16} />}
                                    <span>{item.label}</span>
                                </div>
                                {item.shortcut && (
                                    <span className="text-xs text-[var(--text-tertiary)] ml-4">
                                        {item.shortcut}
                                    </span>
                                )}
                            </button>
                        );
                    })}
                </div>
            </motion.div>
        </AnimatePresence>
    );
};

export default ContextMenu;
