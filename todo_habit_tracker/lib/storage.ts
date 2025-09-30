import type { Task, Habit, DailyProgress } from "@/types"

const STORAGE_KEYS = {
  TASKS: "todo-tracker-tasks",
  HABITS: "todo-tracker-habits",
  PROGRESS: "todo-tracker-progress",
}

export const storage = {
  // Tasks
  getTasks: (): Task[] => {
    if (typeof window === "undefined") return []
    try {
      const tasks = localStorage.getItem(STORAGE_KEYS.TASKS)
      return tasks ? JSON.parse(tasks) : []
    } catch (error) {
      console.error("Error loading tasks:", error)
      return []
    }
  },

  saveTasks: (tasks: Task[]) => {
    if (typeof window === "undefined") return
    try {
      localStorage.setItem(STORAGE_KEYS.TASKS, JSON.stringify(tasks))
    } catch (error) {
      console.error("Error saving tasks:", error)
    }
  },

  // Habits
  getHabits: (): Habit[] => {
    if (typeof window === "undefined") return []
    try {
      const habits = localStorage.getItem(STORAGE_KEYS.HABITS)
      return habits ? JSON.parse(habits) : []
    } catch (error) {
      console.error("Error loading habits:", error)
      return []
    }
  },

  saveHabits: (habits: Habit[]) => {
    if (typeof window === "undefined") return
    try {
      localStorage.setItem(STORAGE_KEYS.HABITS, JSON.stringify(habits))
    } catch (error) {
      console.error("Error saving habits:", error)
    }
  },

  // Progress
  getProgress: (): DailyProgress[] => {
    if (typeof window === "undefined") return []
    try {
      const progress = localStorage.getItem(STORAGE_KEYS.PROGRESS)
      return progress ? JSON.parse(progress) : []
    } catch (error) {
      console.error("Error loading progress:", error)
      return []
    }
  },

  saveProgress: (progress: DailyProgress[]) => {
    if (typeof window === "undefined") return
    try {
      localStorage.setItem(STORAGE_KEYS.PROGRESS, JSON.stringify(progress))
    } catch (error) {
      console.error("Error saving progress:", error)
    }
  },

  exportData: () => {
    if (typeof window === "undefined") return null
    try {
      const data = {
        tasks: storage.getTasks(),
        habits: storage.getHabits(),
        progress: storage.getProgress(),
        exportDate: new Date().toISOString(),
        version: "1.0",
      }
      return JSON.stringify(data, null, 2)
    } catch (error) {
      console.error("Error exporting data:", error)
      return null
    }
  },

  importData: (jsonData: string): boolean => {
    if (typeof window === "undefined") return false
    try {
      const data = JSON.parse(jsonData)

      // Validate data structure
      if (!data.tasks || !data.habits || !Array.isArray(data.tasks) || !Array.isArray(data.habits)) {
        throw new Error("Invalid data format")
      }

      // Import data
      storage.saveTasks(data.tasks)
      storage.saveHabits(data.habits)
      if (data.progress && Array.isArray(data.progress)) {
        storage.saveProgress(data.progress)
      }

      return true
    } catch (error) {
      console.error("Error importing data:", error)
      return false
    }
  },

  clearAllData: () => {
    if (typeof window === "undefined") return
    try {
      localStorage.removeItem(STORAGE_KEYS.TASKS)
      localStorage.removeItem(STORAGE_KEYS.HABITS)
      localStorage.removeItem(STORAGE_KEYS.PROGRESS)
    } catch (error) {
      console.error("Error clearing data:", error)
    }
  },

  getStorageSize: (): number => {
    if (typeof window === "undefined") return 0
    try {
      const tasks = localStorage.getItem(STORAGE_KEYS.TASKS) || ""
      const habits = localStorage.getItem(STORAGE_KEYS.HABITS) || ""
      const progress = localStorage.getItem(STORAGE_KEYS.PROGRESS) || ""
      return new Blob([tasks + habits + progress]).size
    } catch (error) {
      console.error("Error calculating storage size:", error)
      return 0
    }
  },
}
