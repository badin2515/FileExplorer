import React from 'react';
import { X, Check, AlertCircle, Loader2 } from 'lucide-react';
import { useOperations } from '../../contexts/OperationContext';

/**
 * OperationBar Component
 * 
 * Floating bottom bar showing active file operations
 * Non-blocking UI for copy/move/delete progress
 * 
 * Layout:
 * - Title: "Copying 3 items..."
 * - Current file name
 * - Progress: "3 / 10 files • 12.4 MB/s"
 * - Progress bar
 */
const OperationBar = () => {
    const { operations, removeOperation, clearCompleted } = useOperations();

    if (operations.length === 0) return null;

    const getIcon = (status) => {
        if (status === 'running') {
            return <Loader2 size={18} className="animate-spin text-blue-400" />;
        }
        if (status === 'error') {
            return <AlertCircle size={18} className="text-red-400" />;
        }
        if (status === 'done') {
            return <Check size={18} className="text-green-400" />;
        }
        return null;
    };

    const getTitle = (op) => {
        const count = op.totalFiles || op.sources?.length || 0;
        const itemText = count === 1 ? 'item' : 'items';

        switch (op.type) {
            case 'copy':
                return `Copying ${count} ${itemText}...`;
            case 'move':
                return `Moving ${count} ${itemText}...`;
            case 'delete':
                return `Deleting ${count} ${itemText}...`;
            default:
                return 'Processing...';
        }
    };

    const getProgressText = (op) => {
        if (op.status === 'done') {
            const duration = ((op.endTime - op.startTime) / 1000).toFixed(1);
            return `Completed in ${duration}s`;
        }
        if (op.status === 'error') {
            return op.error || 'Failed';
        }

        const count = op.totalFiles || op.sources?.length || 0;
        const current = op.currentIndex || 0;

        // Format speed if available (placeholder for now)
        // TODO: Add actual speed calculation
        return `${current} / ${count} files`;
    };

    return (
        <div
            className="fixed bottom-4 right-4 z-50 flex flex-col gap-2"
            style={{ minWidth: 320, maxWidth: 400 }}
        >
            {operations.map(op => (
                <div
                    key={op.id}
                    className={`
                        flex gap-3 px-4 py-3 rounded-xl shadow-2xl backdrop-blur-md
                        transition-all duration-300
                        ${op.status === 'error' ? 'bg-red-900/95 border border-red-700' : ''}
                        ${op.status === 'done' ? 'bg-green-900/95 border border-green-700' : ''}
                        ${op.status === 'running' ? 'bg-gray-900/95 border border-gray-700' : ''}
                    `}
                >
                    {/* Icon */}
                    <div className="flex-shrink-0 pt-0.5">
                        {getIcon(op.status)}
                    </div>

                    {/* Content */}
                    <div className="flex-1 min-w-0">
                        {/* Title */}
                        <div className="text-sm font-medium text-white">
                            {getTitle(op)}
                        </div>

                        {/* Current file name */}
                        {op.currentFile && op.status === 'running' && (
                            <div className="text-xs text-gray-300 truncate mt-0.5">
                                {op.currentFile}
                            </div>
                        )}

                        {/* Progress text */}
                        <div className="text-xs text-gray-400 mt-1">
                            {getProgressText(op)}
                        </div>

                        {/* Progress bar for running operations */}
                        {op.status === 'running' && (
                            <div className="mt-2 h-1.5 bg-gray-700 rounded-full overflow-hidden">
                                <div
                                    className="h-full bg-blue-500 rounded-full transition-all duration-300"
                                    style={{
                                        width: op.progress > 0 ? `${op.progress}%` : '5%',
                                        animation: op.progress === 0 ? 'pulse 1.5s infinite ease-in-out' : 'none'
                                    }}
                                />
                            </div>
                        )}
                    </div>

                    {/* Dismiss button */}
                    {op.status !== 'running' && (
                        <button
                            onClick={() => removeOperation(op.id)}
                            className="flex-shrink-0 p-1 rounded-lg hover:bg-white/10 transition-colors self-start"
                        >
                            <X size={14} className="text-gray-400" />
                        </button>
                    )}
                </div>
            ))}

            {/* Clear all button if multiple completed */}
            {operations.filter(op => op.status !== 'running').length > 1 && (
                <button
                    onClick={clearCompleted}
                    className="text-xs text-gray-400 hover:text-white transition-colors text-right"
                >
                    Clear all
                </button>
            )}
        </div>
    );
};

export default OperationBar;
