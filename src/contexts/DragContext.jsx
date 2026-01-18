import React, { createContext, useContext, useState, useCallback } from 'react';

/**
 * DragContext
 * 
 * จัดการ state ของ Drag & Drop operation ระหว่าง Panels
 * - เก็บ items ที่กำลังลาก
 * - เก็บ source panel path
 * - ไม่ต้องเก็บ destination (เพราะ drop target ตัดสินใจเอง)
 */

const DragContext = createContext(null);

export const useDrag = () => {
    const context = useContext(DragContext);
    if (!context) {
        throw new Error('useDrag must be used within DragProvider');
    }
    return context;
};

export const DragProvider = ({ children }) => {
    // Drag state
    const [dragData, setDragData] = useState(null);
    // { items: [], sourcePath: string }

    const startDrag = useCallback((items, sourcePath) => {
        setDragData({ items, sourcePath });
    }, []);

    const endDrag = useCallback(() => {
        setDragData(null);
    }, []);

    const isDragging = dragData !== null;

    return (
        <DragContext.Provider value={{
            dragData,
            isDragging,
            startDrag,
            endDrag
        }}>
            {children}
        </DragContext.Provider>
    );
};

export default DragContext;
