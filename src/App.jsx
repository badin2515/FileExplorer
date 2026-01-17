import React, { useState, useEffect } from 'react';
import { AnimatePresence, LayoutGroup, motion } from 'framer-motion';
import { Columns, Square } from 'lucide-react';

// Components
import { Sidebar } from './components/layout';
import { Panel } from './components/panels';
import { PreviewModal, SettingsModal } from './components/modals';

// Get system theme preference
function getSystemTheme() {
  if (typeof window !== 'undefined' && window.matchMedia) {
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }
  return 'light';
}

export default function App() {
  // Dual view state
  const [isDualView, setIsDualView] = useState(false);
  const [activePanel, setActivePanel] = useState('left');

  // Sidebar state
  const [sidebarCollapsed, setSidebarCollapsed] = useState(() => {
    const saved = localStorage.getItem('fileexplorer-sidebar-collapsed');
    return saved === 'true';
  });

  // Sidebar navigation - control active panel's path
  const [leftPanelPath, setLeftPanelPath] = useState('C:\\Users');
  const [rightPanelPath, setRightPanelPath] = useState('C:\\Users');

  // Preview modal state (shared)
  const [previewItem, setPreviewItem] = useState(null);

  // Settings
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);

  // Font size
  const [fontSize, setFontSize] = useState(() => {
    const saved = localStorage.getItem('fileexplorer-fontsize');
    return saved ? parseInt(saved, 10) : 14;
  });

  // Theme state: 'light' | 'dark' | 'system'
  const [theme, setTheme] = useState(() => {
    const saved = localStorage.getItem('fileexplorer-theme');
    return saved || 'system';
  });

  // Calculate font scale (base is 14px)
  const fontScale = fontSize / 14;

  // Get actual theme (resolve 'system' to actual value)
  const actualTheme = theme === 'system' ? getSystemTheme() : theme;

  // Apply theme to document
  useEffect(() => {
    document.documentElement.setAttribute('data-theme', actualTheme);
    localStorage.setItem('fileexplorer-theme', theme);
  }, [theme, actualTheme]);

  // Listen for system theme changes
  useEffect(() => {
    if (theme !== 'system') return;

    const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
    const handler = () => {
      document.documentElement.setAttribute('data-theme', getSystemTheme());
    };

    mediaQuery.addEventListener('change', handler);
    return () => mediaQuery.removeEventListener('change', handler);
  }, [theme]);

  // Save font size to localStorage and apply CSS variable
  useEffect(() => {
    localStorage.setItem('fileexplorer-fontsize', fontSize.toString());
    document.documentElement.style.setProperty('--font-scale', fontScale.toString());
  }, [fontSize, fontScale]);

  // Save sidebar state to localStorage
  useEffect(() => {
    localStorage.setItem('fileexplorer-sidebar-collapsed', sidebarCollapsed.toString());
  }, [sidebarCollapsed]);

  // Handle sidebar navigation - navigates the active panel
  const handleSidebarNavigate = (path) => {
    if (activePanel === 'left') {
      setLeftPanelPath(path);
    } else {
      setRightPanelPath(path);
    }
  };

  // Get current path based on active panel
  const currentPath = activePanel === 'left' ? leftPanelPath : rightPanelPath;

  return (
    <div
      className="app-container theme-transition flex h-screen overflow-hidden"
      style={{
        '--font-scale': fontScale,
        backgroundColor: 'var(--bg-primary)'
      }}
    >
      {/* Sidebar */}
      <Sidebar
        currentPath={currentPath}
        onNavigate={handleSidebarNavigate}
        onOpenSettings={() => setIsSettingsOpen(true)}
        collapsed={sidebarCollapsed}
        onToggleCollapse={() => setSidebarCollapsed(!sidebarCollapsed)}
      />

      {/* Main Content - Panels */}
      <main className="flex-1 flex flex-col min-w-0 overflow-hidden">
        {/* Top Bar with Dual View Toggle */}
        <div
          className="h-12 px-4 flex items-center justify-between"
          style={{
            backgroundColor: 'var(--bg-secondary)',
            borderBottom: '1px solid var(--border-color)'
          }}
        >
          <span className="text-sm font-medium" style={{ color: 'var(--text-tertiary)' }}>
            {isDualView ? 'Dual Panel View' : 'Single Panel View'}
          </span>

          <button
            onClick={() => setIsDualView(!isDualView)}
            className="flex items-center gap-2 px-3 py-1.5 rounded-lg text-sm font-medium transition-all"
            style={{
              backgroundColor: isDualView ? 'var(--accent-primary)' : 'var(--bg-tertiary)',
              color: isDualView ? 'white' : 'var(--text-tertiary)',
            }}
          >
            {isDualView ? <Square size={16} /> : <Columns size={16} />}
            <span>{isDualView ? 'Single View' : 'Dual View'}</span>
          </button>
        </div>

        {/* Panels Container */}
        <LayoutGroup>
          <motion.div
            layout
            className="flex-1 flex overflow-hidden"
          >
            {/* Left Panel (always visible) */}
            <Panel
              panelId="left"
              isActive={activePanel === 'left'}
              onActivate={() => setActivePanel('left')}
              showBorder={false}
              sourcePath={leftPanelPath}
              onPathChange={setLeftPanelPath}
            />

            {/* Right Panel (only in dual view) */}
            <AnimatePresence mode="popLayout">
              {isDualView && (
                <Panel
                  panelId="right"
                  isActive={activePanel === 'right'}
                  onActivate={() => setActivePanel('right')}
                  showBorder={true}
                  sourcePath={rightPanelPath}
                  onPathChange={setRightPanelPath}
                />
              )}
            </AnimatePresence>
          </motion.div>
        </LayoutGroup>
      </main>

      {/* File Preview Modal */}
      <AnimatePresence>
        {previewItem && (
          <PreviewModal
            item={previewItem}
            breadcrumbs={[]}
            onClose={() => setPreviewItem(null)}
          />
        )}
      </AnimatePresence>

      {/* Settings Modal */}
      <SettingsModal
        isOpen={isSettingsOpen}
        onClose={() => setIsSettingsOpen(false)}
        fontSize={fontSize}
        onFontSizeChange={setFontSize}
        theme={theme}
        onThemeChange={setTheme}
      />
    </div>
  );
}
