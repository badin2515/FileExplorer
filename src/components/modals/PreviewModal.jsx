import { motion } from 'framer-motion';
import { X } from 'lucide-react';
import { FileIcon } from '../files';

/**
 * InfoRow Component
 * Displays a label-value pair in the preview modal
 */
const InfoRow = ({ label, value }) => (
    <div className="flex justify-between items-center">
        <span className="text-sm text-[#9a958e]">{label}</span>
        <span className="text-sm text-[#2d2a26] font-medium">{value}</span>
    </div>
);

/**
 * PreviewModal Component
 * Displays file details in a modal overlay
 */
const PreviewModal = ({ item, breadcrumbs, onClose }) => (
    <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="fixed inset-0 z-50 flex items-center justify-center p-8 bg-black/30 backdrop-blur-sm"
        onClick={onClose}
    >
        <motion.div
            initial={{ opacity: 0, scale: 0.95, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.95, y: 20 }}
            transition={{ type: "spring", damping: 25, stiffness: 300 }}
            className="bg-white rounded-3xl shadow-2xl w-full max-w-md overflow-hidden"
            onClick={e => e.stopPropagation()}
        >
            {/* Preview Header */}
            <div className="p-8 bg-gradient-to-br from-[#f5f3f0] to-[#eae6e0] flex items-center justify-center">
                <motion.div initial={{ scale: 0.8 }} animate={{ scale: 1 }} transition={{ delay: 0.1 }}>
                    <FileIcon type={item.type} name={item.name} size={56} />
                </motion.div>
            </div>

            {/* Preview Content */}
            <div className="p-6">
                <div className="flex justify-between items-start mb-6">
                    <div className="flex-1 min-w-0 pr-4">
                        <h3 className="font-bold text-lg text-[#2d2a26] truncate">{item.name}</h3>
                        <p className="text-sm text-[#9a958e] mt-0.5">
                            {item.type === 'folder' ? 'Folder' : item.name.split('.').pop().toUpperCase() + ' File'}
                        </p>
                    </div>
                    <button
                        onClick={onClose}
                        className="p-2 hover:bg-[#f5f3f0] rounded-full text-[#9a958e] transition-colors"
                    >
                        <X size={20} />
                    </button>
                </div>

                <div className="space-y-3 mb-6 p-4 bg-[#faf8f5] rounded-xl">
                    <InfoRow label="Size" value={item.size || '--'} />
                    <InfoRow label="Modified" value={item.date || '--'} />
                    <InfoRow label="Location" value={breadcrumbs?.map(b => b.name).join(' / ') || '--'} />
                </div>

                <div className="flex gap-3">
                    <button className="flex-1 py-3 bg-[#d97352] text-white rounded-xl font-medium hover:bg-[#c55a3a] transition-colors shadow-lg shadow-[#d97352]/20">
                        Download
                    </button>
                    <button className="flex-1 py-3 bg-[#f5f3f0] text-[#2d2a26] rounded-xl font-medium hover:bg-[#eae6e0] transition-colors">
                        Share
                    </button>
                </div>
            </div>
        </motion.div>
    </motion.div>
);

export default PreviewModal;
