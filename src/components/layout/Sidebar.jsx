import { motion, AnimatePresence } from 'framer-motion';
import {
    Folder, FileText, Home, Download, Image as ImageIcon,
    Music, Video, HardDrive, Monitor, RefreshCw, Smartphone, Settings,
    ChevronLeft, ChevronRight
} from 'lucide-react';
import { useStorageVolumes } from '../../hooks/useTauri';

/**
 * SidebarButton Component with smooth animations
 */
const SidebarButton = ({ icon: Icon, label, active, onClick, badge, color, collapsed }) => (
    <motion.button
        onClick={onClick}
        title={collapsed ? label : undefined}
        whileHover={{ scale: 1.02, x: collapsed ? 0 : 4 }}
        whileTap={{ scale: 0.98 }}
        transition={{ type: "spring", stiffness: 400, damping: 25 }}
        className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl transition-colors duration-200 text-sm font-medium ${collapsed ? 'justify-center' : ''}`}
        style={{
            backgroundColor: active ? 'var(--accent-primary)' : 'transparent',
            color: active ? 'white' : 'var(--text-secondary)',
            boxShadow: active ? '0 4px 12px var(--accent-light)' : 'none',
        }}
    >
        <motion.div
            animate={{ rotate: active ? [0, -10, 10, 0] : 0 }}
            transition={{ duration: 0.4, ease: "easeInOut" }}
        >
            <Icon size={18} className={active ? 'text-white' : (color || 'text-[#9a958e]')} />
        </motion.div>
        <AnimatePresence mode="wait">
            {!collapsed && (
                <motion.div
                    initial={{ opacity: 0, width: 0 }}
                    animate={{ opacity: 1, width: "auto" }}
                    exit={{ opacity: 0, width: 0 }}
                    transition={{ duration: 0.2, ease: "easeOut" }}
                    className="flex-1 flex items-center justify-between min-w-0"
                >
                    <span className="truncate">{label}</span>
                    {badge && (
                        <motion.span
                            initial={{ scale: 0 }}
                            animate={{ scale: 1 }}
                            className={`ml-2 px-2 py-0.5 text-xs rounded-full flex-shrink-0 ${active ? 'bg-white/20 text-white' : 'bg-[#eae6e0] text-[#7a756e]'}`}
                        >
                            {badge}
                        </motion.span>
                    )}
                </motion.div>
            )}
        </AnimatePresence>
    </motion.button>
);

/**
 * Section Header with animation
 */
const SectionHeader = ({ children, collapsed }) => (
    <AnimatePresence>
        {!collapsed && (
            <motion.p
                initial={{ opacity: 0, y: -10 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -10 }}
                transition={{ duration: 0.2 }}
                className="px-3 mb-2 text-xs font-semibold uppercase tracking-wider"
                style={{ color: 'var(--text-muted)' }}
            >
                {children}
            </motion.p>
        )}
    </AnimatePresence>
);

/**
 * Get Windows user folders paths
 */
function getWindowsFolders() {
    const userProfile = 'C:\\Users\\Bordin';

    return {
        home: userProfile,
        documents: `${userProfile}\\Documents`,
        pictures: `${userProfile}\\Pictures`,
        downloads: `${userProfile}\\Downloads`,
        music: `${userProfile}\\Music`,
        videos: `${userProfile}\\Videos`,
        desktop: `${userProfile}\\Desktop`,
    };
}

/**
 * Sidebar Component with enhanced animations
 */
const Sidebar = ({ currentPath, onNavigate, onOpenSettings, collapsed, onToggleCollapse }) => {
    const folders = getWindowsFolders();
    const { volumes, loading: volumesLoading, refresh: refreshVolumes } = useStorageVolumes();

    const isActive = (path) => currentPath?.toLowerCase() === path?.toLowerCase();

    // Animation variants
    const sidebarVariants = {
        expanded: {
            width: 288,
            transition: {
                type: "spring",
                stiffness: 300,
                damping: 30,
                staggerChildren: 0.05
            }
        },
        collapsed: {
            width: 72,
            transition: {
                type: "spring",
                stiffness: 300,
                damping: 30,
                staggerChildren: 0.03,
                staggerDirection: -1
            }
        }
    };

    const logoTextVariants = {
        expanded: {
            opacity: 1,
            x: 0,
            display: "block",
            transition: { delay: 0.1, duration: 0.2 }
        },
        collapsed: {
            opacity: 0,
            x: -20,
            transitionEnd: { display: "none" },
            transition: { duration: 0.15 }
        }
    };

    return (
        <motion.aside
            initial={false}
            animate={collapsed ? "collapsed" : "expanded"}
            variants={sidebarVariants}
            className="flex flex-col flex-shrink-0 overflow-hidden"
            style={{
                backgroundColor: 'var(--bg-secondary)',
                borderRight: '1px solid var(--border-color)',
            }}
        >
            {/* Logo Header */}
            <motion.div
                className="p-4"
                style={{ borderBottom: '1px solid var(--border-color)' }}
                animate={{ padding: collapsed ? "12px" : "24px 24px 16px 24px" }}
                transition={{ duration: 0.3 }}
            >
                <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                        <motion.div
                            className="w-10 h-10 bg-gradient-to-br from-[#d97352] to-[#c55a3a] rounded-xl flex items-center justify-center shadow-lg shadow-[#d97352]/25 flex-shrink-0"
                            whileHover={{ scale: 1.05, rotate: 5 }}
                            whileTap={{ scale: 0.95 }}
                        >
                            <Folder size={20} className="text-white" />
                        </motion.div>
                        <motion.div
                            variants={logoTextVariants}
                            className="overflow-hidden"
                        >
                            <h1 className="text-lg font-bold whitespace-nowrap" style={{ color: 'var(--text-primary)' }}>FileExplorer</h1>
                            <p className="text-xs whitespace-nowrap" style={{ color: 'var(--text-muted)' }}>Windows ↔ Android</p>
                        </motion.div>
                    </div>
                    <AnimatePresence>
                        {!collapsed && (
                            <motion.button
                                initial={{ opacity: 0, scale: 0.8 }}
                                animate={{ opacity: 1, scale: 1 }}
                                exit={{ opacity: 0, scale: 0.8 }}
                                whileHover={{ scale: 1.1, rotate: 90 }}
                                whileTap={{ scale: 0.9 }}
                                transition={{ duration: 0.2 }}
                                onClick={onOpenSettings}
                                className="p-2 rounded-lg transition-colors"
                                style={{ color: 'var(--text-muted)' }}
                                title="Settings"
                            >
                                <Settings size={18} />
                            </motion.button>
                        )}
                    </AnimatePresence>
                </div>
            </motion.div>

            {/* Scrollable Content */}
            <div className="flex-1 overflow-y-auto overflow-x-hidden">
                {/* Quick Access */}
                <motion.div
                    className="p-4"
                    animate={{ padding: collapsed ? "16px 8px" : "16px" }}
                >
                    <SectionHeader collapsed={collapsed}>Quick Access</SectionHeader>
                    <nav className="space-y-1">
                        <SidebarButton
                            icon={Home}
                            label="Home"
                            active={isActive(folders.home)}
                            onClick={() => onNavigate(folders.home)}
                            collapsed={collapsed}
                        />
                        <SidebarButton
                            icon={Monitor}
                            label="Desktop"
                            active={isActive(folders.desktop)}
                            onClick={() => onNavigate(folders.desktop)}
                            collapsed={collapsed}
                        />
                    </nav>
                </motion.div>

                {/* User Folders */}
                <motion.div
                    className="p-4"
                    animate={{ padding: collapsed ? "16px 8px" : "16px" }}
                >
                    <SectionHeader collapsed={collapsed}>Folders</SectionHeader>
                    <nav className="space-y-1">
                        <SidebarButton
                            icon={FileText}
                            label="Documents"
                            onClick={() => onNavigate(folders.documents)}
                            active={isActive(folders.documents)}
                            color="text-blue-500"
                            collapsed={collapsed}
                        />
                        <SidebarButton
                            icon={ImageIcon}
                            label="Pictures"
                            onClick={() => onNavigate(folders.pictures)}
                            active={isActive(folders.pictures)}
                            color="text-purple-500"
                            collapsed={collapsed}
                        />
                        <SidebarButton
                            icon={Download}
                            label="Downloads"
                            onClick={() => onNavigate(folders.downloads)}
                            active={isActive(folders.downloads)}
                            color="text-green-500"
                            collapsed={collapsed}
                        />
                        <SidebarButton
                            icon={Music}
                            label="Music"
                            onClick={() => onNavigate(folders.music)}
                            active={isActive(folders.music)}
                            color="text-pink-500"
                            collapsed={collapsed}
                        />
                        <SidebarButton
                            icon={Video}
                            label="Videos"
                            onClick={() => onNavigate(folders.videos)}
                            active={isActive(folders.videos)}
                            color="text-red-500"
                            collapsed={collapsed}
                        />
                    </nav>
                </motion.div>

                {/* Drives */}
                <motion.div
                    className="p-4"
                    animate={{ padding: collapsed ? "16px 8px" : "16px" }}
                >
                    <AnimatePresence>
                        {!collapsed && (
                            <motion.div
                                initial={{ opacity: 0 }}
                                animate={{ opacity: 1 }}
                                exit={{ opacity: 0 }}
                                className="flex items-center justify-between px-3 mb-2"
                            >
                                <p className="text-xs font-semibold uppercase tracking-wider" style={{ color: 'var(--text-muted)' }}>Drives</p>
                                <motion.button
                                    onClick={refreshVolumes}
                                    whileHover={{ rotate: 180 }}
                                    transition={{ duration: 0.3 }}
                                    className="p-1 rounded transition-colors"
                                    disabled={volumesLoading}
                                    style={{ color: 'var(--text-muted)' }}
                                >
                                    <RefreshCw size={12} className={volumesLoading ? 'animate-spin' : ''} />
                                </motion.button>
                            </motion.div>
                        )}
                    </AnimatePresence>
                    <nav className="space-y-1">
                        {volumes.map((volume, index) => (
                            <motion.div
                                key={volume.path}
                                initial={{ opacity: 0, x: -20 }}
                                animate={{ opacity: 1, x: 0 }}
                                transition={{ delay: index * 0.05 }}
                            >
                                <SidebarButton
                                    icon={HardDrive}
                                    label={volume.name}
                                    onClick={() => onNavigate(volume.path)}
                                    active={isActive(volume.path)}
                                    color="text-[#87a878]"
                                    collapsed={collapsed}
                                />
                            </motion.div>
                        ))}
                        {volumes.length === 0 && !volumesLoading && (
                            <SidebarButton
                                icon={HardDrive}
                                label="C:\\"
                                onClick={() => onNavigate('C:\\')}
                                active={isActive('C:\\')}
                                color="text-[#87a878]"
                                collapsed={collapsed}
                            />
                        )}
                    </nav>
                </motion.div>

                {/* Connected Devices */}
                <motion.div
                    className="p-4"
                    style={{ borderTop: '1px solid var(--border-color)' }}
                    animate={{ padding: collapsed ? "16px 8px" : "16px" }}
                >
                    <SectionHeader collapsed={collapsed}>Devices</SectionHeader>
                    <motion.div
                        className="py-4 text-center"
                        animate={{ padding: collapsed ? "16px 4px" : "16px 12px" }}
                    >
                        <motion.div
                            animate={{
                                y: [0, -3, 0],
                            }}
                            transition={{
                                duration: 2,
                                repeat: Infinity,
                                ease: "easeInOut"
                            }}
                        >
                            <Smartphone size={collapsed ? 20 : 24} className="mx-auto mb-2" style={{ color: 'var(--text-faint)' }} />
                        </motion.div>
                        <AnimatePresence>
                            {!collapsed && (
                                <motion.div
                                    initial={{ opacity: 0 }}
                                    animate={{ opacity: 1 }}
                                    exit={{ opacity: 0 }}
                                >
                                    <p className="text-xs" style={{ color: 'var(--text-muted)' }}>No devices connected</p>
                                    <p className="text-[10px] mt-1" style={{ color: 'var(--text-faint)' }}>Connect Android to transfer files</p>
                                </motion.div>
                            )}
                        </AnimatePresence>
                    </motion.div>
                </motion.div>
            </div>

            {/* Collapse Toggle Button */}
            <motion.div
                className="p-3"
                style={{ borderTop: '1px solid var(--border-color)' }}
            >
                <motion.button
                    onClick={onToggleCollapse}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    className="w-full flex items-center justify-center gap-2 px-3 py-2.5 rounded-xl transition-colors"
                    style={{ color: 'var(--text-tertiary)' }}
                    title={collapsed ? "Expand sidebar" : "Collapse sidebar"}
                >
                    <motion.div
                        animate={{ rotate: collapsed ? 180 : 0 }}
                        transition={{ type: "spring", stiffness: 200, damping: 15 }}
                    >
                        <ChevronLeft size={18} />
                    </motion.div>
                    <AnimatePresence>
                        {!collapsed && (
                            <motion.span
                                initial={{ opacity: 0, width: 0 }}
                                animate={{ opacity: 1, width: "auto" }}
                                exit={{ opacity: 0, width: 0 }}
                                className="text-sm overflow-hidden whitespace-nowrap"
                            >
                                Collapse
                            </motion.span>
                        )}
                    </AnimatePresence>
                </motion.button>
            </motion.div>
        </motion.aside>
    );
};

export default Sidebar;
