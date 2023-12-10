import matplotlib.pyplot as plt
import pandas as pd


def clean_baseline(csv_path):
    df_baseline = pd.read_csv(csv_path, index_col=0)
    time_err = df_baseline.iloc[0, :-3]
    time_err.index = time_err.index.astype(float)

    return time_err

def main():

    dx = '1.5mm'
    times = r'$\times$'
    n_iter = 5

    fig_path  = f'relative_error_origin_shift_{dx}.png'
    fig, ax = plt.subplots()

    for i in range(n_iter):

        # Load and prepare data
        error_path = f'P_STE/{dx}_{i}/relative_error_{dx}_{i}.csv'
        rel_error = clean_baseline(error_path)

        # Plot Data
        # FIXME: I'm not grabbing the time stuff??? WHY
        ax.plot(rel_error, label=f'Origin Shift {i+1}')

    # Format Plot
    ax.legend(fontsize=10)
    ax.set_ylabel('Relative Error (%)', fontsize=10)
    ax.set_xlabel('Time (s)', fontsize=10)
    ax.set_title(f'Shifted Origin Analysis: Relative Error Over Time for {dx[:-2]} mm {times} 60 ms', fontsize=10)
    ax.set_ylim(bottom=0, top=50)
    fig.tight_layout()
    fig.savefig(fig_path, dpi=400)

if __name__ == "__main__":
    main()