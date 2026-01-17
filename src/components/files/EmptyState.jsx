import { motion } from 'framer-motion';
import { Folder } from 'lucide-react';

/**
 * EmptyState Component
 * Displays when a folder is empty or no search results
 */
const EmptyState = ({ searchQuery }) => (
    <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="flex flex-col items-center justify-center py-16 text-center"
    >
        <div className="p-6 bg-[#f5f3f0] rounded-full mb-4">
            <Folder size={40} strokeWidth={1.5} className="text-[#c4bfb6]" />
        </div>
        <p className="font-semibold text-[#5c5955] mb-1">
            {searchQuery ? 'No files found' : 'This folder is empty'}
        </p>
        <p className="text-sm text-[#9a958e]">
            {searchQuery ? 'Try a different search term' : 'Drop files here or click "New" to add'}
        </p>
    </motion.div>
);

export default EmptyState;
