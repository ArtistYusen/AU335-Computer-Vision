import cv2
import numpy as np
import matplotlib.pyplot as plt


def task_1():
  src = cv2.imread("../images/medium/2-1.jpg")
  plt.cla()
  plt.imshow(src)
  plt.show()


if __name__ == "__main__":
  task_1()