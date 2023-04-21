import torch as th
import torch.nn as nn
import torch.nn.functional as F
from modules.critics.mlp import MLP


class PartitionMapper():

    mapping = {
        3:{
            0:0,
            1:1,
            2:2
        },
        4:{
            0: 0,
            1: 1,
            2: 2,
            3: 2
        },
        5:{
            0: 0,
            1: 1,
            2: 1,
            3: 2,
            4: 2
        },
        6:{
            0: 0,
            1: 0,
            2: 1,
            3: 1,
            4: 2,
            5: 2
        },
        7:{
            0: 0,
            1: 0,
            2: 1,
            3: 1,
            4: 2,
            5: 2,
            6: 2
        },
        8:{
            0: 0,
            1: 0,
            2: 1,
            3: 1,
            4: 1,
            5: 2,
            6: 2,
            7: 2
        },
        9:{
            0: 0,
            1: 0,
            2: 0,
            3: 1,
            4: 1,
            5: 1,
            6: 2,
            7: 2,
            8: 2
        }
    }

    n_agent: int
    n_partitions: int
    def __init__(self, agents, partitions):
        self.n_agent = agents
        self.n_partitions = partitions
    def map(self, agent):
        return self.mapping[self.n_agent][agent]

class PMADDPGCritic(nn.Module):
    partition: PartitionMapper
    n_partitions: int

    def __init__(self, scheme, args):
        super(PMADDPGCritic, self).__init__()
        self.n_partitions = 3
        self.args = args
        self.n_actions = args.n_actions
        self.n_agents = args.n_agents
        self.partition = PartitionMapper(agents=self.n_agents, partitions=self.n_partitions)
        self.input_shape = self._get_input_shape(scheme) + self.n_actions * self.n_agents
        if self.args.obs_last_action:
            self.input_shape += self.n_actions
        self.output_type = "q"
        self.critics = [MLP(self.input_shape, self.args.hidden_dim, 1) for _ in range(self.n_partitions)]

    def forward(self, inputs, actions):
        inputs = th.cat((inputs, actions), dim=-1)
        qs = []
        for i in range(self.n_agents):
            q = self.critics[self.partition.map(i)](inputs[:, :, i]).unsqueeze(2)
            qs.append(q)
        return th.cat(qs, dim=2)

    def _get_input_shape(self, scheme):
        # state
        input_shape = scheme["state"]["vshape"]
        # observation
        if self.args.obs_individual_obs:
            input_shape += scheme["obs"]["vshape"]
        return input_shape

    def parameters(self):
        params = list(self.critics[self.partition.map(0)].parameters())
        for i in range(1, self.n_agents):
            params += list(self.critics[self.partition.map(i)].parameters())
        return params

    def state_dict(self):
        result = []
        for i in range(self.n_agents):
            result.append(self.critics[self.partition.map(i)].state_dict())
        return result
        #return [a.state_dict() for a in self.critics]

    def load_state_dict(self, state_dict):
        for i, c in enumerate(self.critics):
            c.load_state_dict(state_dict[i])

    def cuda(self):
        for c in self.critics:
            c.cuda()
