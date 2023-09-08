## Preparation in advance  


```bash

gcloud compute networks create default --subnet-mode=auto

packer init -upgrade ubuntu-gce.json.pkr.hcl

packer build .

```
