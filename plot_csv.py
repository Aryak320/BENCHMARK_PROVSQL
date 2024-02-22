import pandas as pd
import matplotlib.pyplot as plt


df = pd.read_csv('execution_times.csv')


df.set_index('SQL File', inplace=True)


fig, axs = plt.subplots(3, 1, figsize=(6, 36))


df.plot(kind='barh', ax=axs[0])

axs[0].set_title('Execution Times of SQL Queries')
axs[0].set_ylabel('SQL File')
axs[0].set_xlabel('Execution Time (ms)')


df.plot(kind='barh', ax=axs[1], logx=True)

axs[1].set_title('Execution Times of SQL Queries (Log Scale)')
axs[1].set_ylabel('SQL File')
axs[1].set_xlabel('Execution Time (ms) (Log Scale)')


total_times = df.sum()


total_times.plot(kind='barh', ax=axs[2])


axs[2].set_title('Total Execution Time for Each Database')
axs[2].set_xlabel('Execution Time (ms)')
axs[2].set_ylabel('Database')


plt.tight_layout()
plt.show()

