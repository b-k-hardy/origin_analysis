import matplotlib.pyplot as plt
import pandas as pd


def clean_baseline(csv_path):
    df_baseline = pd.read_csv(csv_path, index_col=0)
    time_err = df_baseline.iloc[0, :-3]
    time_err.index = time_err.index.astype(float)

    return time_err

def main():

    times = r'$\times$'

    fig_path  = 'relative_error_origin_shift.png'
    fig, ax = plt.subplots()

    for i in range(3):

        # RELATIVE ERROR STUFF
        # Load and prepare data
        baseline_path = f'3.0mm_{i}_pressure/relative_error_{i}.csv'
        baseline_error = clean_baseline(baseline_path)

        # Plot Data
        ax.plot(baseline_error, label=f'Origin Shift {i+1}')

    # Format Plot
    ax.legend(fontsize=10)
    ax.set_ylabel('Relative Error (%)', fontsize=10)
    ax.set_xlabel('Time (s)', fontsize=10)
    ax.set_title(f'Shifted Origin Analysis: Relative Error Over Time for 3.0 mm {times} 60 ms', fontsize=10)
    ax.set_ylim(bottom=0, top=50)
    fig.tight_layout()
    fig.savefig(fig_path, dpi=400)

if __name__ == "__main__":
    main()