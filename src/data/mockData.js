export const mockFileSystem = [
    {
        id: 'root',
        name: 'Home',
        type: 'folder',
        children: [
            {
                id: '1',
                name: 'Documents',
                type: 'folder',
                children: [
                    { id: '11', name: 'Project Alpha', type: 'folder', children: [] },
                    { id: '12', name: 'Financials', type: 'folder', children: [] },
                    { id: '13', name: 'Report 2024.pdf', type: 'file', size: '2.5 MB', date: '2024-01-15' },
                    { id: '14', name: 'Notes.txt', type: 'file', size: '12 KB', date: '2024-01-14' },
                ]
            },
            {
                id: '2',
                name: 'Images',
                type: 'folder',
                children: [
                    { id: '21', name: 'Wallpapers', type: 'folder', children: [] },
                    { id: '22', name: 'Screenshots', type: 'folder', children: [] },
                    { id: '23', name: 'Avatar.png', type: 'file', size: '1.2 MB', date: '2024-01-10' },
                    { id: '24', name: 'Design_Mockup.fig', type: 'file', size: '15 MB', date: '2024-01-08' },
                ]
            },
            {
                id: '3',
                name: 'Downloads',
                type: 'folder',
                children: [
                    { id: '31', name: 'Installer_v2.exe', type: 'file', size: '45 MB', date: '2024-01-16' }
                ]
            },
            { id: '4', name: 'Music', type: 'folder', children: [] },
            { id: '5', name: 'Videos', type: 'folder', children: [] },
            { id: '6', name: 'todo_list.md', type: 'file', size: '2 KB', date: '2024-01-17' },
        ]
    }
];
