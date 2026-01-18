import React, { forwardRef } from 'react';
import { AnimatePresence } from 'framer-motion';
import FileRow from './FileRow';
import FileCard from './FileCard';
import EmptyState from './EmptyState';

/**
 * FileArea Component
 * Displays files in list or grid view
 * Optimized for mouse + keyboard navigation + drag/drop
 * Uses forwardRef to allow parent to control scroll position
 */
const FileArea = forwardRef(({
    items,
    viewMode,
    selectedIds,
    cutIds, // Set<string>
    searchQuery,
    onSelect,
    onNavigate,
    onClearSelection,
    currentPath,
    onContextMenu, // (e, item) => void
    onDragStart,   // (item, isSelected) => void
    onDropOnItem,  // (targetPath, ctrlKey) => void
    isDragging     // boolean
}, ref) => (
    <div
        ref={ref}
        className="flex-1 overflow-auto"
        style={{ backgroundColor: 'var(--bg-secondary)' }}
        onClick={onClearSelection}
        onContextMenu={(e) => {
            e.preventDefault();
            if (onContextMenu) onContextMenu(e, null);
        }}
    >
        {viewMode === 'list' ? (
            <div className="min-w-full">
                {/* Table Header */}
                <div
                    className="flex items-center px-3 py-2 text-xs font-medium uppercase tracking-wide sticky top-0 z-10 select-none"
                    style={{
                        backgroundColor: 'var(--bg-tertiary)',
                        borderBottom: '1px solid var(--border-color)',
                        color: 'var(--text-muted)'
                    }}
                >
                    <span style={{ flex: 1, minWidth: 200 }}>Name</span>
                    <span style={{ width: 100, textAlign: 'right' }}>Size</span>
                    <span style={{ width: 150, textAlign: 'right', paddingRight: 12 }}>Modified</span>
                </div>

                {/* File Rows */}
                <div>
                    {items.map((item, index) => (
                        <FileRow
                            key={item.id}
                            item={item}
                            index={index}
                            selected={selectedIds.has(item.id)}
                            isCut={cutIds?.has(item.id)}
                            onSelect={onSelect}
                            onNavigate={onNavigate}
                            onContextMenu={onContextMenu}
                            onDragStart={onDragStart}
                            onDrop={onDropOnItem}
                            isDragging={isDragging}
                        />
                    ))}
                </div>

                {/* Empty State */}
                {items.length === 0 && (
                    <EmptyState searchQuery={searchQuery} />
                )}
            </div>
        ) : (
            <div
                className="grid gap-2 p-2"
                style={{ gridTemplateColumns: 'repeat(auto-fill, minmax(100px, 1fr))' }}
            >
                <AnimatePresence mode="popLayout">
                    {items.map((item, index) => (
                        <FileCard
                            key={item.id}
                            item={item}
                            index={index}
                            selected={selectedIds.has(item.id)}
                            isCut={cutIds?.has(item.id)}
                            onSelect={onSelect}
                            onNavigate={onNavigate}
                            onContextMenu={onContextMenu}
                            onDragStart={onDragStart}
                            onDrop={onDropOnItem}
                            isDragging={isDragging}
                        />
                    ))}
                </AnimatePresence>

                {items.length === 0 && (
                    <div className="col-span-full">
                        <EmptyState searchQuery={searchQuery} />
                    </div>
                )}
            </div>
        )}
    </div>
));

FileArea.displayName = 'FileArea';

export default FileArea;
