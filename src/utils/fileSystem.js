/**
 * File System Utility Functions
 */

/**
 * Find a folder by ID in a nested file system structure
 */
export const findFolder = (items, id) => {
    for (const item of items) {
        if (item.id === id) return item;
        if (item.children) {
            const found = findFolder(item.children, id);
            if (found) return found;
        }
    }
    return null;
};

/**
 * Get breadcrumb path to a target folder
 */
export const getBreadcrumbs = (items, targetId, path = []) => {
    for (const item of items) {
        if (item.id === targetId) return [...path, item];
        if (item.children) {
            const found = getBreadcrumbs(item.children, targetId, [...path, item]);
            if (found) return found;
        }
    }
    return null;
};
