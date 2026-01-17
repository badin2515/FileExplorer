import { motion, AnimatePresence } from 'framer-motion';
import FileRow from './FileRow';
import FileCard from './FileCard';
import EmptyState from './EmptyState';

/**
 * FileArea Component
 * Displays files in list or grid view
 * Reusable for dual panel system
 */
const FileArea = ({
    items,
    viewMode,
    selectedIds,
    searchQuery,
    onSelect,
    onNavigate,
    onClearSelection,
    currentPath
}) => (
    <div
        className="flex-1 overflow-auto p-4 bg-[#f8f6f3]"
        onClick={onClearSelection}
    >
        <AnimatePresence mode="wait">
            {viewMode === 'list' ? (
                <motion.div
                    key={currentPath + '-list'}
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    exit={{ opacity: 0 }}
                    className="bg-white rounded-2xl border border-[#eae6e0] overflow-hidden"
                >
                    {/* Table Header */}
                    <div className="flex items-center px-5 py-3 bg-[#faf8f5] border-b border-[#eae6e0] text-xs font-semibold text-[#9a958e] uppercase tracking-wider">
                        <span style={{ flex: 1 }}>Name</span>
                        <span style={{ width: 100 }}>Size</span>
                        <span style={{ width: 140 }}>Modified</span>
                        <span style={{ width: 50 }}></span>
                    </div>

                    {/* File Rows */}
                    <div className="divide-y divide-[#f0ece6]">
                        {items.map((item, index) => (
                            <FileRow
                                key={item.id}
                                item={item}
                                index={index}
                                selected={selectedIds.has(item.id)}
                                onSelect={(multi) => onSelect(item.id, multi)}
                                onNavigate={() => onNavigate(item)}
                            />
                        ))}
                    </div>

                    {/* Empty State */}
                    {items.length === 0 && (
                        <EmptyState searchQuery={searchQuery} />
                    )}
                </motion.div>
            ) : (
                <motion.div
                    key={currentPath + '-grid'}
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    exit={{ opacity: 0 }}
                    className="grid gap-4"
                    style={{ gridTemplateColumns: 'repeat(auto-fill, minmax(140px, 1fr))' }}
                >
                    {items.map((item, index) => (
                        <FileCard
                            key={item.id}
                            item={item}
                            index={index}
                            selected={selectedIds.has(item.id)}
                            onSelect={(multi) => onSelect(item.id, multi)}
                            onNavigate={() => onNavigate(item)}
                        />
                    ))}

                    {items.length === 0 && (
                        <div className="col-span-full">
                            <EmptyState searchQuery={searchQuery} />
                        </div>
                    )}
                </motion.div>
            )}
        </AnimatePresence>
    </div>
);

export default FileArea;
