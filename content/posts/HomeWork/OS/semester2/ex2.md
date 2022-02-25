# 实验二

```python
import random
from functools import reduce
from typing import List
import copy

MAX_RESOURCE_SIZE: int = 10


class Process():
    def __init__(self, index: int, resource_type_num: int, max: List[int], requests: List[List[int]]):
        self.index = index
        self.resource_type_num = resource_type_num
        # 最大需求
        self.max: list[int] = max
        # 已分配
        self.allocation: list[int] = [0 for _ in range(resource_type_num)]
        # 是否完成
        self.is_done = False
        self.is_blocked = False
        self.requests: List[List[int]] = requests
        self.step = 0  # 请求步骤

    @property
    def need(self) -> List[int]:
        """
        需求
        """
        return list(map(lambda x, y: x-y, self.max, self.allocation))

    def request(self) -> List[int]:
        """
        发出资源请求
        """
        return self.requests[self.step]

    def release_all_resources(self):
        self.allocation = [0 for _ in range(self.resource_type_num)]


class AllocationApp():
    """
    分配模拟程序
    """

    def __init__(self, resource_type_num: int, process_num: int,
                 available: List[int], p_max: List[List[int]],
                 p_requests: List[List[List[int]]]):
        # 进程实例列表
        self.ori_processes: List[Process] = [
            Process(i, resource_type_num, p_max[i], p_requests[i]) for i in range(process_num)]
        # 初始资源总量列表
        self.ori_available: List[int] = available

    @property
    def processes(self) -> List[Process]:
        """
        未完成的资源实例列表
        """
        return [p for p in self.ori_processes if not p.is_done]

    @property
    def not_blocked_processes(self) -> List[Process]:
        """
        未完成且未阻塞的资源实例列表
        """
        return [p for p in self.ori_processes if not p.is_done and not p.is_blocked]

    @property
    def max(self) -> List[List[int]]:
        """
        最大需求
        """
        return [process.max for process in self.processes]

    @property
    def need(self) -> List[List[int]]:
        """
        需求
        """
        return [process.need for process in self.processes]

    @property
    def allocation(self) -> List[List[int]]:
        """
       已分配
        """
        return [process.allocation for process in self.processes]

    @property
    def available(self) -> List[int]:
        """
        剩余资源
        """
        if self.allocation:
            allocated = reduce(lambda x, y: list(
                map(lambda a, b: a+b, x, y)), self.allocation)
            return list(map(lambda x, y: x-y, self.ori_available, allocated))
        else:
            return self.ori_available

    def is_all_finished(self) -> bool:
        """
        进程是否全部结束
        """
        return True if len(self.processes) == 0 else False

    def is_all_blocked(self) -> bool:
        """
        进程是否全部阻塞
        """
        return True if False not in [p.is_blocked for p in self.processes] else False

    def judge_request_n_need(self, process: Process, request: list[int]) -> bool:
        """
        判断请求是否小于需求
        """
        difference = list(map(lambda x, y: True if x >= y else False,
                              process.need, request))
        if False not in difference:
            return True
        else:
            return False

    def judge_request_n_available(self, request: list[int]) -> bool:
        """
        判断请求是否小于资源量
        """
        difference = list(map(lambda x, y: True if x >= y else False,
                              self.available, request))
        if False not in difference:
            return True
        else:
            return False

    def try_allocate(self, p: Process,  request: list[int]):
        """
        试分配
        """
        p.allocation = list(
            map(lambda x, y: x+y, p.allocation, request))

        available = copy.deepcopy(self.available)
        allocation = copy.deepcopy(self.allocation)
        need = copy.deepcopy(self.need)

        p.allocation = list(
            map(lambda x, y: x-y, p.allocation, request))
        # # 减少已有资源
        # available = list(map(lambda x, y: x-y, available, request))
        # # 增加进程 p的已有资源
        # allocation[p.index] = list(
        #     map(lambda x, y: x+y, allocation[p.index], request))
        # # 减少进程 p的需求
        # need[p.index] = list(
        #     map(lambda x, y: x-y, need[p.index], request))

        return available, allocation, need

    def allocate(self,  p: Process,  request: list[int]):
        """
        正式为请求分配资源
        """
        # 增加进程 p的已有资源
        p.allocation = list(
            map(lambda x, y: x+y, p.allocation, request))
        # 进程 p的需求need会自动减少

        # 修改进程实例参数
        p.step += 1
        if p.step == len(p.requests):
            print("进程 {} 运行结束".format(p.index+1))
            p.is_done = True
            p.release_all_resources()

    def banker_check(self, available: List[List[int]],
                     allocation: List[List[int]], need: List[List[int]]) -> bool:
        """
        银行家算法，判断系统是否处于安全状态
        """
        work = copy.deepcopy(available)
        finish = [False for _ in range(len(self.processes))]
        while True:
            for i in range(len(self.processes)):
                # 找到一个可分配进程
                if finish[i] == False \
                        and False not in map(lambda _avail, _need: True if _avail >= _need else False,
                                             work, need[i]):
                    # 释放进程所有资源
                    work = list(
                        map(lambda x, y: x+y, allocation[i], work))
                    finish[i] = True
                    break
            else:
                # 自然结束，说明找不到安全序列
                return False
            if False not in finish:
                return True

    def run(self, option: bool = True):
        """
        入口函数
        """
        queue: List[int, Process, List[int], bool] = []  # 请求的阻塞队列
        block_state = False  # 处于全部阻塞的状态
        while not self.is_all_finished():
            print('------------------------------------------')
            print('系统剩余资源 [{}]'.format(', '.join(map(str, self.available))))
            if self.is_all_blocked():
                block_state = True
                p, request, _ = queue.pop()
                p.is_blocked = False
            else:
                block_state = False
                # 随机选取机制, 以模拟进程异步地发出请求的过程
                p: Process = random.choice(self.not_blocked_processes)
                request: list[int] = p.request()  # 取进程当前的资源请求
            print('进程 {} 申请 [{}]'.format(
                p.index+1, ', '.join(map(str, request))))
            if self.judge_request_n_need(p, request):
                if self.judge_request_n_available(request):
                    if option:
                        # 试分配
                        is_safe = self.banker_check(
                            *self.try_allocate(p, request))
                        if is_safe:
                            print('进程 {} 成功申请 [{}]'.format(
                                p.index+1,
                                ', '.join(map(str, request))
                            ))
                            self.allocate(p, request)
                        else:
                            # 不安全
                            print('分配资源后, 系统将处于不安全状态, 请求阻塞')
                            p.is_blocked = True
                            queue.insert(0,
                                         [p, request, False if block_state else True])
                            if queue and True not in [q[-1] for q in queue]:
                                # 此时所有处于阻塞的进程的请求都无法得到满足
                                print('系统资源不足，退出分配')
                                break
                    else:
                        self.allocate(p, request)
                else:
                    # 尚无足够资源
                    print('系统没有足够资源, 请求阻塞')
                    p.is_blocked = True
                    queue.insert(0,
                                 [p, request, False if block_state else True])
                    if queue and True not in [q[-1] for q in queue]:
                        # 此时所有处于阻塞的进程的请求都无法得到满足
                        print('系统资源不足，退出分配!')
                        break

            else:
                # 请求大于需求，出错
                print('请求大于需求, 驳回请求')
                break


if __name__ == '__main__':
    config = {
        "resource_type_num": 3,
        "process_num": 2,
        "available": [6, 7, 5],
        "p_max": [
            [6, 7, 5],
            [4, 6, 3],
        ],
        "p_requests": [
            [
                [3, 5, 1], [2, 1, 3], [1, 1, 1]
            ],
            [
                [3, 2, 1], [0, 4, 2]
            ]
        ]
    }
    allocation_app = AllocationApp(**config)
    allocation_app.run(True)
```

