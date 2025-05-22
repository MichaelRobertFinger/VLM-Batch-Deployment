---
language:
- en
license: cc-by-4.0
size_categories:
- 1K<n<10K
task_categories:
- feature-extraction
pretty_name: FATURA 2 invoices
tags:
- invoices
- data extraction
- invoice
- FATURA2
configs:
- config_name: default
  data_files:
  - split: train
    path: data/train-*
  - split: test
    path: data/test-*
dataset_info:
  features:
  - name: image
    dtype: image
  - name: ner_tags
    sequence: int64
  - name: bboxes
    sequence:
      sequence: int64
  - name: tokens
    sequence: string
  - name: id
    dtype: string
  splits:
  - name: train
    num_bytes: 411874484.6
    num_examples: 8600
  - name: test
    num_bytes: 60569760.6
    num_examples: 1400
  download_size: 342750666
  dataset_size: 472444245.20000005
---


The dataset consists of 10000 jpg images with white backgrounds, 10000 jpg images with colored backgrounds (the same colors used in the paper) as well as 3x10000 json annotation files. The images are generated from 50 different templates.

https://zenodo.org/records/10371464

---
dataset_info:
  features:
  - name: image
    dtype: image
  - name: ner_tags
    sequence: int64
  - name: words
    sequence: string
  - name: bboxes
    sequence:
      sequence: int64
  splits:
  - name: train
    num_bytes: 477503369.0
    num_examples: 10000
  download_size: 342662174
  dataset_size: 477503369.0
configs:
- config_name: default
  data_files:
  - split: train
    path: data/train-*
---

@misc{limam2023fatura, title={FATURA: A Multi-Layout Invoice Image Dataset for Document Analysis and Understanding}, author={Mahmoud Limam and Marwa Dhiaf and Yousri Kessentini}, year={2023}, eprint={2311.11856}, archivePrefix={arXiv}, primaryClass={cs.CV} }