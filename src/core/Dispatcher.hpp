// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <queue>
#include <mutex>
#include <condition_variable>
#include <functional>
#include <atomic>

namespace velocity::core {

class Dispatcher {
public:
    using Task = std::function<void()>;

    Dispatcher() : m_running(true) {}
    ~Dispatcher() {
        stop();
    }

    void post(Task task) {
        {
            std::lock_guard<std::mutex> lock(m_mutex);
            m_tasks.push(std::move(task));
        }
        m_cv.notify_one();
    }

    void drain() {
        std::queue<Task> localQueue;
        {
            std::lock_guard<std::mutex> lock(m_mutex);
            std::swap(localQueue, m_tasks);
        }
        while (!localQueue.empty()) {
            if (localQueue.front()) {
                localQueue.front()();
            }
            localQueue.pop();
        }
    }

    void stop() {
        m_running = false;
        m_cv.notify_all();
    }

    bool isRunning() const {
        return m_running;
    }

    size_t pendingTasks() const {
        std::lock_guard<std::mutex> lock(m_mutex);
        return m_tasks.size();
    }

private:
    mutable std::mutex m_mutex;
    std::condition_variable m_cv;
    std::queue<Task> m_tasks;
    std::atomic<bool> m_running;
};

} // namespace velocity::core
