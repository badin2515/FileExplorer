import { Folder, FileText, Image as ImageIcon, Music, Video } from 'lucide-react';

/**
 * FileIcon Component
 * Displays appropriate icon based on file type and extension
 */
const FileIcon = ({ type, name, size = 20 }) => {
    const ext = name.split('.').pop().toLowerCase();

    const iconStyles = {
        folder: { bg: 'bg-amber-100', icon: 'text-amber-600', fill: 'fill-amber-200' },
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

    return (
        <div className={`p-2.5 ${style.bg} rounded-xl transition-transform duration-200`}>
            <IconComponent
                className={`${style.icon} ${style.fill || ''}`}
                size={size}
                strokeWidth={type === 'folder' ? 1.5 : 2}
            />
        </div>
    );
};

export default FileIcon;
