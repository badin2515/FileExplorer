import { motion, AnimatePresence } from 'framer-motion';
import { X, Type, Minus, Plus, Sun, Moon, Monitor } from 'lucide-react';

/**
 * Settings Modal Component
 * ปรับขนาด text และ theme
 */
const SettingsModal = ({ isOpen, onClose, fontSize, onFontSizeChange, theme, onThemeChange }) => {
    const fontSizes = [
        { value: 12, label: 'Small' },
        { value: 14, label: 'Medium' },
        { value: 16, label: 'Large' },
        { value: 18, label: 'Extra Large' },
    ];

    const themes = [
        { value: 'light', label: 'Light', icon: Sun },
        { value: 'dark', label: 'Dark', icon: Moon },
        { value: 'system', label: 'System', icon: Monitor },
    ];

    const handleDecrease = () => {
        const newSize = Math.max(10, fontSize - 1);
        onFontSizeChange(newSize);
    };

    const handleIncrease = () => {
        const newSize = Math.min(24, fontSize + 1);
        onFontSizeChange(newSize);
    };

    return (
        <AnimatePresence>
            {isOpen && (
                <>
                    {/* Backdrop */}
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        onClick={onClose}
                        className="fixed inset-0 bg-black/30 backdrop-blur-sm z-50"
                    />

                    {/* Modal */}
                    <motion.div
                        initial={{ opacity: 0, scale: 0.95, y: 20 }}
                        animate={{ opacity: 1, scale: 1, y: 0 }}
                        exit={{ opacity: 0, scale: 0.95, y: 20 }}
                        transition={{ type: "spring", damping: 25, stiffness: 300 }}
                        className="fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 
                                   w-[420px] rounded-2xl shadow-2xl z-50 overflow-hidden"
                        style={{
                            backgroundColor: 'var(--bg-secondary)',
                            borderColor: 'var(--border-color)',
                            border: '1px solid var(--border-color)'
                        }}
                    >
                        {/* Header */}
                        <div
                            className="flex items-center justify-between px-6 py-4"
                            style={{ borderBottom: '1px solid var(--border-color)' }}
                        >
                            <h2 className="text-lg font-bold" style={{ color: 'var(--text-primary)' }}>Settings</h2>
                            <button
                                onClick={onClose}
                                className="p-2 rounded-lg transition-colors"
                                style={{ color: 'var(--text-tertiary)' }}
                            >
                                <X size={18} />
                            </button>
                        </div>

                        {/* Content */}
                        <div className="p-6 space-y-8">
                            {/* Theme Selection */}
                            <div>
                                <div className="flex items-center gap-2 mb-4">
                                    <Sun size={18} style={{ color: 'var(--accent-primary)' }} />
                                    <h3 className="text-sm font-semibold" style={{ color: 'var(--text-primary)' }}>
                                        Appearance
                                    </h3>
                                </div>

                                <div className="flex gap-3">
                                    {themes.map(({ value, label, icon: Icon }) => (
                                        <motion.button
                                            key={value}
                                            onClick={() => onThemeChange(value)}
                                            whileHover={{ scale: 1.02 }}
                                            whileTap={{ scale: 0.98 }}
                                            className="flex-1 flex flex-col items-center gap-2 p-4 rounded-xl transition-all"
                                            style={{
                                                backgroundColor: theme === value ? 'var(--accent-light)' : 'var(--bg-tertiary)',
                                                border: theme === value ? '2px solid var(--accent-primary)' : '2px solid transparent',
                                            }}
                                        >
                                            <Icon
                                                size={24}
                                                style={{
                                                    color: theme === value ? 'var(--accent-primary)' : 'var(--text-muted)'
                                                }}
                                            />
                                            <span
                                                className="text-sm font-medium"
                                                style={{
                                                    color: theme === value ? 'var(--accent-primary)' : 'var(--text-secondary)'
                                                }}
                                            >
                                                {label}
                                            </span>
                                        </motion.button>
                                    ))}
                                </div>
                            </div>

                            {/* Font Size */}
                            <div>
                                <div className="flex items-center gap-2 mb-4">
                                    <Type size={18} style={{ color: 'var(--accent-primary)' }} />
                                    <h3 className="text-sm font-semibold" style={{ color: 'var(--text-primary)' }}>
                                        Text Size
                                    </h3>
                                </div>

                                {/* Size Control */}
                                <div
                                    className="flex items-center justify-between rounded-xl p-4"
                                    style={{ backgroundColor: 'var(--bg-tertiary)' }}
                                >
                                    <motion.button
                                        onClick={handleDecrease}
                                        disabled={fontSize <= 10}
                                        whileHover={{ scale: 1.05 }}
                                        whileTap={{ scale: 0.95 }}
                                        className="p-2 rounded-lg shadow-sm transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                                        style={{ backgroundColor: 'var(--bg-secondary)' }}
                                    >
                                        <Minus size={16} style={{ color: 'var(--text-tertiary)' }} />
                                    </motion.button>

                                    <div className="text-center">
                                        <span className="text-2xl font-bold" style={{ color: 'var(--text-primary)' }}>
                                            {fontSize}
                                        </span>
                                        <span className="text-sm ml-1" style={{ color: 'var(--text-muted)' }}>px</span>
                                    </div>

                                    <motion.button
                                        onClick={handleIncrease}
                                        disabled={fontSize >= 24}
                                        whileHover={{ scale: 1.05 }}
                                        whileTap={{ scale: 0.95 }}
                                        className="p-2 rounded-lg shadow-sm transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                                        style={{ backgroundColor: 'var(--bg-secondary)' }}
                                    >
                                        <Plus size={16} style={{ color: 'var(--text-tertiary)' }} />
                                    </motion.button>
                                </div>

                                {/* Preset Sizes */}
                                <div className="flex gap-2 mt-3">
                                    {fontSizes.map(({ value, label }) => (
                                        <button
                                            key={value}
                                            onClick={() => onFontSizeChange(value)}
                                            className="flex-1 py-2 px-3 rounded-lg text-xs font-medium transition-all"
                                            style={{
                                                backgroundColor: fontSize === value ? 'var(--accent-primary)' : 'var(--bg-tertiary)',
                                                color: fontSize === value ? 'white' : 'var(--text-tertiary)',
                                            }}
                                        >
                                            {label}
                                        </button>
                                    ))}
                                </div>

                                {/* Preview */}
                                <div
                                    className="mt-4 p-4 rounded-xl"
                                    style={{
                                        backgroundColor: 'var(--bg-tertiary)',
                                        border: '1px solid var(--border-color)'
                                    }}
                                >
                                    <p className="text-xs mb-2" style={{ color: 'var(--text-muted)' }}>Preview</p>
                                    <p style={{ fontSize: `${fontSize}px`, color: 'var(--text-primary)' }}>
                                        Sample text - ตัวอย่างข้อความ
                                    </p>
                                    <p style={{ fontSize: `${fontSize - 2}px`, color: 'var(--text-tertiary)' }} className="mt-1">
                                        File name.txt - 2.5 MB
                                    </p>
                                </div>
                            </div>
                        </div>

                        {/* Footer */}
                        <div
                            className="px-6 py-4 flex justify-end gap-3"
                            style={{
                                backgroundColor: 'var(--bg-tertiary)',
                                borderTop: '1px solid var(--border-color)'
                            }}
                        >
                            <button
                                onClick={() => {
                                    onFontSizeChange(14);
                                    onThemeChange('system');
                                }}
                                className="px-4 py-2 text-sm font-medium transition-colors"
                                style={{ color: 'var(--text-tertiary)' }}
                            >
                                Reset to Default
                            </button>
                            <motion.button
                                onClick={onClose}
                                whileHover={{ scale: 1.02 }}
                                whileTap={{ scale: 0.98 }}
                                className="px-4 py-2 rounded-lg text-sm font-medium text-white"
                                style={{ backgroundColor: 'var(--accent-primary)' }}
                            >
                                Done
                            </motion.button>
                        </div>
                    </motion.div>
                </>
            )}
        </AnimatePresence>
    );
};

export default SettingsModal;
