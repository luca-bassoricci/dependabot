service:
  type: LoadBalancer

mongodb:
  strategyType: Recreate

image:
  pullPolicy: Always
