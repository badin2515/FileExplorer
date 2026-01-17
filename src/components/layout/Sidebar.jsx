import { motion } from 'framer-motion';
import {
    Folder, FileText, Home, Download, Image as ImageIcon,
    Music, Video, Cloud, HardDrive, Star, Clock, Trash2
} from 'lucide-react';

/**
 * SidebarButton Component
 * A button used in the sidebar navigation
 */
const SidebarButton = ({ icon: Icon, label, active, onClick, badge, color }) => (
    <button
        onClick={onClick}
        className={`
      w-full flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all duration-200 text-sm font-medium
      ${active
                ? 'bg-[#d97352] text-white shadow-lg shadow-[#d97352]/20'
                : 'text-[#5c5955] hover:bg-[#f5f3f0] hover:text-[#2d2a26]'
            }
    `}
    >
        <Icon size={18} className={active ? 'text-white' : (color || 'text-[#9a958e]')} />
        <span className="flex-1 text-left">{label}</span>
        {badge && (
            <span className={`px-2 py-0.5 text-xs rounded-full ${active ? 'bg-white/20 text-white' : 'bg-[#eae6e0] text-[#7a756e]'}`}>
                {badge}
            </span>
        )}
    </button>
);

/**
 * Sidebar Component
 * Main navigation sidebar with quick access, folders, and storage info
 */
const Sidebar = ({ currentPath, onNavigate }) => {
    return (
        <motion.aside
            initial={{ x: -20, opacity: 0 }}
            animate={{ x: 0, opacity: 1 }}
            transition={{ duration: 0.4, ease: "easeOut" }}
            className="w-72 bg-white border-r border-[#eae6e0] flex flex-col"
        >
            {/* Logo Header */}
            <div className="p-6 border-b border-[#eae6e0]">
                <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-gradient-to-br from-[#d97352] to-[#c55a3a] rounded-xl flex items-center justify-center shadow-lg shadow-[#d97352]/25">
                        <Folder size={20} className="text-white" />
                    </div>
                    <div>
                        <h1 className="text-lg font-bold text-[#2d2a26]">FileVault</h1>
                        <p className="text-xs text-[#9a958e]">Cloud Storage</p>
                    </div>
                </div>
            </div>

            {/* Quick Access */}
            <div className="p-4">
                <p className="px-3 mb-2 text-xs font-semibold text-[#9a958e] uppercase tracking-wider">Quick Access</p>
                <nav className="space-y-1">
                    <SidebarButton
                        icon={Home}
                        label="Home"
                        active={currentPath === 'root'}
                        onClick={() => onNavigate('root')}
                        badge={null}
                    />
                    <SidebarButton icon={Clock} label="Recent" badge="12" />
                    <SidebarButton icon={Star} label="Favorites" badge="5" />
                    <SidebarButton icon={Trash2} label="Trash" badge={null} />
                </nav>
            </div>

            {/* Folders */}
            <div className="p-4 flex-1">
                <p className="px-3 mb-2 text-xs font-semibold text-[#9a958e] uppercase tracking-wider">Folders</p>
                <nav className="space-y-1">
                    <SidebarButton
                        icon={FileText}
                        label="Documents"
                        onClick={() => onNavigate('1')}
                        active={currentPath === '1'}
                        color="text-blue-500"
                    />
                    <SidebarButton
                        icon={ImageIcon}
                        label="Images"
                        onClick={() => onNavigate('2')}
                        active={currentPath === '2'}
                        color="text-purple-500"
                    />
                    <SidebarButton
                        icon={Download}
                        label="Downloads"
                        onClick={() => onNavigate('3')}
                        active={currentPath === '3'}
                        color="text-green-500"
                    />
                    <SidebarButton
                        icon={Music}
                        label="Music"
                        onClick={() => onNavigate('4')}
                        active={currentPath === '4'}
                        color="text-pink-500"
                    />
                    <SidebarButton
                        icon={Video}
                        label="Videos"
                        onClick={() => onNavigate('5')}
                        active={currentPath === '5'}
                        color="text-red-500"
                    />
                </nav>
            </div>

            {/* Storage Card */}
            <div className="p-4 m-4 bg-gradient-to-br from-[#f5f3f0] to-[#eae6e0] rounded-2xl">
                <div className="flex items-center gap-3 mb-4">
                    <div className="p-2 bg-white rounded-xl shadow-sm">
                        <HardDrive size={18} className="text-[#87a878]" />
                    </div>
                    <div className="flex-1">
                        <p className="text-sm font-semibold text-[#2d2a26]">Storage</p>
                        <p className="text-xs text-[#9a958e]">15 GB of 20 GB</p>
                    </div>
                    <span className="text-sm font-bold text-[#d97352]">75%</span>
                </div>
                <div className="h-2 w-full bg-white rounded-full overflow-hidden shadow-inner">
                    <motion.div
                        initial={{ width: 0 }}
                        animate={{ width: '75%' }}
                        transition={{ duration: 1, ease: "easeOut", delay: 0.3 }}
                        className="h-full bg-gradient-to-r from-[#87a878] to-[#a3c494] rounded-full"
                    />
                </div>
                <button className="w-full mt-4 py-2.5 text-sm font-medium text-[#d97352] bg-white rounded-xl hover:bg-[#faf8f5] transition-colors shadow-sm">
                    Upgrade Plan
                </button>
            </div>
        </motion.aside>
    );
};

export default Sidebar;
