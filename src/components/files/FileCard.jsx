import { motion } from 'framer-motion';
import FileIcon from './FileIcon';

/**
 * FileCard Component
 * Displays a file/folder as a card in grid view
 */
const FileCard = ({ item, index, selected, onSelect, onNavigate }) => (
    <motion.div
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.2, delay: index * 0.03 }}
        onClick={(e) => {
            e.stopPropagation();
            onSelect(e.metaKey || e.ctrlKey);
        }}
        onDoubleClick={onNavigate}
        className={`
      group p-4 bg-white rounded-2xl border cursor-pointer transition-all duration-200
      ${selected
                ? 'border-[#d97352] bg-[#fef8f5] shadow-lg shadow-[#d97352]/10'
                : 'border-[#eae6e0] hover:border-[#d4cfc5] hover:shadow-md'
            }
    `}
    >
        <div className="flex flex-col items-center text-center">
            <motion.div
                whileHover={{ scale: 1.1, rotate: item.type === 'file' ? 3 : 0 }}
                className="mb-3"
            >
                <FileIcon type={item.type} name={item.name} size={32} />
            </motion.div>
            <p className="font-medium text-[#2d2a26] text-sm truncate w-full mb-1">{item.name}</p>
            <p className="text-xs text-[#9a958e]">
                {item.size || (item.type === 'folder' ? `${item.children?.length || 0} items` : '--')}
            </p>
        </div>
    </motion.div>
);

export default FileCard;
