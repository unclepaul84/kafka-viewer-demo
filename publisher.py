from struct import pack
from confluent_kafka import Producer

import gen.python.protos.Trade_pb2  as Trade_pb2
import uuid

conf = {'bootstrap.servers': "localhost:29092"}

    # Create Producer instance
p = Producer(**conf)


trade = Trade_pb2.TradeTopic()
trade.tradeEvent.qty = 1
trade.tradeEvent.price = 100.0

p.produce(topic="sys-50-trades", partition=0, key=str(uuid.uuid4()), value=trade.SerializeToString())
p.produce(topic="sys-51-trades", partition=0, key=str(uuid.uuid4()), value=trade.SerializeToString())
p.flush()