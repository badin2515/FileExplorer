import { motion } from 'framer-motion';
import { MoreHorizontal } from 'lucide-react';
import FileIcon from './FileIcon';

/**
 * FileRow Component
 * Displays a file/folder as a row in list view
 */
const FileRow = ({ item, index, selected, onSelect, onNavigate }) => (
    <motion.div
        initial={{ opacity: 0, y: 8 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.15, delay: index * 0.02 }}
        onClick={(e) => {
            e.stopPropagation();
            onSelect(e.metaKey || e.ctrlKey);
        }}
        onDoubleClick={onNavigate}
        className={`
      group flex items-center px-5 py-3.5 cursor-pointer transition-all duration-150
      ${selected ? 'bg-[#fef3ed]' : 'hover:bg-[#faf8f5]'}
    `}
    >
        {/* Name */}
        <div className="flex items-center gap-3 min-w-0" style={{ flex: 1 }}>
            <motion.div whileHover={{ scale: 1.05 }} whileTap={{ scale: 0.95 }}>
                <FileIcon type={item.type} name={item.name} size={18} />
            </motion.div>
            <span className="font-medium text-[#2d2a26] truncate text-sm">{item.name}</span>
        </div>

        {/* Size */}
        <span className="text-sm text-[#7a756e]" style={{ width: 100 }}>
            {item.size || (item.type === 'folder' ? `${item.children?.length || 0} items` : '--')}
        </span>

        {/* Date */}
        <span className="text-sm text-[#7a756e]" style={{ width: 140 }}>{item.date || '--'}</span>

        {/* Actions */}
        <button
            onClick={(e) => e.stopPropagation()}
            className="p-1.5 rounded-lg opacity-0 group-hover:opacity-100 hover:bg-[#eae6e0] text-[#9a958e] transition-all"
            style={{ width: 50, display: 'flex', justifyContent: 'center' }}
        >
            <MoreHorizontal size={16} />
        </button>
    </motion.div>
);

export default FileRow;
