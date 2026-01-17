import FileIcon from './FileIcon';

/**
 * FileCard Component
 * Compact icon view for grid mode
 */
const FileCard = ({ item, index, selected, onSelect, onNavigate }) => (
    <div
        onClick={(e) => {
            e.stopPropagation();
            onSelect(e.metaKey || e.ctrlKey);
        }}
        onDoubleClick={onNavigate}
        className="flex flex-col items-center p-2 cursor-pointer select-none rounded"
        style={{
            backgroundColor: selected ? 'var(--accent-light)' : 'transparent',
            border: selected ? '1px solid var(--accent-primary)' : '1px solid transparent',
        }}
        onMouseOver={(e) => {
            if (!selected) {
                e.currentTarget.style.backgroundColor = 'var(--bg-hover)';
            }
        }}
        onMouseOut={(e) => {
            if (!selected) {
                e.currentTarget.style.backgroundColor = 'transparent';
            }
        }}
    >
        <FileIcon type={item.type} name={item.name} size={32} />
        <span
            className="text-xs truncate w-full text-center mt-1"
            style={{ color: 'var(--text-primary)' }}
        >
            {item.name}
        </span>
    </div>
);

export default FileCard;
