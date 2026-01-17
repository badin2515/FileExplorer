import React, { useState } from 'react';
import { AnimatePresence, LayoutGroup, motion } from 'framer-motion';
import { Columns, Square } from 'lucide-react';

// Components
import { Sidebar } from './components/layout';
import { Panel } from './components/panels';
import { PreviewModal } from './components/modals';

export default function App() {
  // Dual view state
  const [isDualView, setIsDualView] = useState(false);
  const [activePanel, setActivePanel] = useState('left');

  // Preview modal state (shared)
  const [previewItem, setPreviewItem] = useState(null);

  return (
    <div className="flex h-screen overflow-hidden bg-[#f8f6f3]">
      {/* Sidebar */}
      <Sidebar
        currentPath="root"
        onNavigate={() => { }}
        isDualView={isDualView}
        onToggleDualView={() => setIsDualView(!isDualView)}
      />

      {/* Main Content - Panels */}
      <main className="flex-1 flex flex-col min-w-0 overflow-hidden">
        {/* Top Bar with Dual View Toggle */}
        <div className="h-12 px-4 bg-white border-b border-[#eae6e0] flex items-center justify-between">
          <span className="text-sm font-medium text-[#7a756e]">
            {isDualView ? 'Dual Panel View' : 'Single Panel View'}
          </span>

          <button
            onClick={() => setIsDualView(!isDualView)}
            className={`
              flex items-center gap-2 px-3 py-1.5 rounded-lg text-sm font-medium transition-all
              ${isDualView
                ? 'bg-[#d97352] text-white shadow-sm'
                : 'bg-[#f5f3f0] text-[#7a756e] hover:bg-[#eae6e0]'
              }
            `}
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
            />

            {/* Right Panel (only in dual view) */}
            <AnimatePresence mode="popLayout">
              {isDualView && (
                <Panel
                  panelId="right"
                  isActive={activePanel === 'right'}
                  onActivate={() => setActivePanel('right')}
                  showBorder={true}
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
    </div>
  );
}
