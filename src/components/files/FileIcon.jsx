import { Folder, FileText, Image as ImageIcon, Music, Video } from 'lucide-react';

/**
 * FileIcon Component
 * Displays appropriate icon based on file type and extension
 */
const FileIcon = ({ type, name, size = 20, variant = 'filled' }) => {
    const ext = name.split('.').pop().toLowerCase();

    // Color tokens mapped to CSS variables or Tailwind classes
    const iconStyles = {
        folder: {
            bg: 'bg-amber-100',
            icon: 'text-amber-500',
            fill: 'fill-amber-400/20'
        },
        image: { bg: 'bg-violet-100', icon: 'text-violet-500' },
        audio: { bg: 'bg-rose-100', icon: 'text-rose-500' },
        video: { bg: 'bg-red-100', icon: 'text-red-500' },
        pdf: { bg: 'bg-orange-100', icon: 'text-orange-600' },
        default: { bg: 'bg-stone-100', icon: 'text-stone-500' }
    };

    let style = iconStyles.default;
    let IconComponent = FileText;

    if (type === 'folder') {
        style = iconStyles.folder;
        IconComponent = Folder;
    } else if (['jpg', 'png', 'gif', 'svg', 'webp'].includes(ext)) {
        style = iconStyles.image;
        IconComponent = ImageIcon;
    } else if (['mp3', 'wav', 'flac'].includes(ext)) {
        style = iconStyles.audio;
        IconComponent = Music;
    } else if (['mp4', 'mov', 'avi'].includes(ext)) {
        style = iconStyles.video;
        IconComponent = Video;
    } else if (ext === 'pdf') {
        style = iconStyles.pdf;
    }

    if (variant === 'simple') {
        return (
            <div
                className="flex items-center justify-center flex-shrink-0"
                style={{ width: size + 4, height: size + 4 }}
            >
                <IconComponent
                    className={`${style.icon} ${style.fill || ''}`}
                    size={size}
                    strokeWidth={1.5}
                />
            </div>
        );
    }

    return (
        <div className={`p-2.5 ${style.bg} rounded-xl flex items-center justify-center`}>
            <IconComponent
                className={`${style.icon} ${style.fill || ''}`}
                size={size}
                strokeWidth={type === 'folder' ? 1.5 : 2}
            />
        </div>
    );
};

export default FileIcon;
