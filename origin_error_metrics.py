import numpy as np
import h5py
import pandas as pd

## STANDARD FUNCTIONS ##
# input: error matrix (error for all pressure voxels for all timesteps)
# output: 1-D vector of root mean square error for that timestep
def rmse_timesteps(errors):
    return np.sqrt(np.sum(np.square(errors), axis=0)/errors.shape[0])

# input: error matrix (error for all pressure voxels for all timesteps)
# output: RMSE for all voxels across all timesteps
def rmse_total(errors):
    return np.sqrt(np.sum(np.square(errors)/errors.size))

# "relative error" normalized by MAXIMUM of denominator (i.e. maximum of square root of sum of pressures at each timestep)
def relative_error_timesteps(errors, pressures):
    return np.sqrt(np.sum(np.square(errors), axis=0))/(np.max(np.sqrt(np.sum(np.square(pressures), axis=0))))*100

# NOTE: This is still "classic" relative error, but I could also modify this...
def relative_error_total(errors, pressures):
    return np.sqrt(np.sum(np.square(errors)))/(np.sqrt(np.sum(np.square(pressures))))*100


def main():

    # create headers for csv's (default vWERP times are wrong for this particular dataset)
    time_60ms = str(np.arange(0.035, 0.996, 0.060))[1:-1].split()

    dx = '1.5mm'

    # loop through all variations of sensitivity analysis
    for i in range(5):
        
        # update user about progress
        print(f'Iteration {i}')

        # create out paths for tables            
        out_path_RMSE = f'3.0mm_{i}_pressure/RMSE_{i}.csv'
        out_path_relative_error = f'3.0mm_{i}_pressure/relative_error_{i}.csv'

        # path to ground truth data
        gt_path = f'3.0mm_{i}_pressure/UM13_0.75mm_60ms_P_CFD_shifted.mat'

        # create path for error mask
        error_mask_path = f'3.0mm_{i}_pressure/UM13_3.0mm_{i}_error_mask.mat'

        # path to error data
        data_path = f'3.0mm_{i}_pressure/UM13_3.0mm_60ms_P_ERR.mat'

        # LOAD DATA
        # load ground truth data
        with h5py.File(gt_path, 'r') as f:
            p_cfd = f['P'][:].T

        # load error mask
        with h5py.File(error_mask_path, 'r') as f:
            error_mask = f['mask'][:].T.astype(bool)

        # allocate rmse matrix. literally just one row (for the one case per dx/dt combo)
        rmse_matrix = np.zeros((1, len(time_60ms)+3))
        relative_matrix = np.zeros((1, len(time_60ms)+3))

        # load data
        with h5py.File(data_path, 'r') as f:
            error_map = f['P_ERR'][:].T

        # create ground truth matrix
        p_cfd_matrix = p_cfd[error_mask]
        # create error matrix
        error_matrix = error_map[error_mask]

        # get RMSE for each timestep
        rmse_matrix[:, :-3] = rmse_timesteps(error_matrix) # place errors into correct row, leaving last column empty (this is for total rmse across ALL timesteps)
        rmse_matrix[:, -3] = rmse_total(error_matrix)

        relative_matrix[:, :-3] = relative_error_timesteps(error_matrix, p_cfd_matrix)
        relative_matrix[:, -3] = relative_error_total(error_matrix, p_cfd_matrix)
                
        # NOTE: uncomment if you want nicely formatted units... removing for now so I can use the csv's for plotting more easily
        #col_labels_fmt = [T[dt][i] + ' s' for i in range(len(T[dt]))]
        col_labels_fmt = time_60ms
        col_labels = col_labels_fmt + ['All Timesteps', 'Maximum Error Timestep', 'Maximum Error Over Timesteps']
        idx_labels = ["Error"]
        
        # convert to pandas dataframe to have better export formatting
        df_RMSE = pd.DataFrame(rmse_matrix, columns=col_labels)
        df_RMSE.index = idx_labels
        df_RMSE.index.name = 'Time (s)'

        df_relative_error = pd.DataFrame(relative_matrix, columns=col_labels)
        df_relative_error.index = idx_labels
        df_relative_error.index.name = 'Time (s)'

        # get argmax and max for each row (excluding total RMSE)
        max_err_time_idx = np.argmax(rmse_matrix[:, :-3], axis=1)
        time_val = [time_60ms[max_err_time_idx[i]] for i in range(max_err_time_idx.size)] # some overly-fancy list comprehension that maybe I don't need but at least it works for now
        df_RMSE.iloc[:,-2] = time_val
        df_RMSE.iloc[:, -1] = rmse_matrix[np.arange(rmse_matrix.shape[0]), max_err_time_idx]
        df_RMSE.to_csv(out_path_RMSE, float_format='%.6f')

        max_err_time_idx = np.argmax(relative_matrix[:, :-3], axis=1)
        time_val = [time_60ms[max_err_time_idx[i]] for i in range(max_err_time_idx.size)]
        df_relative_error.iloc[:,-2] = time_val
        df_relative_error.iloc[:,-1] = relative_matrix[np.arange(relative_matrix.shape[0]), max_err_time_idx]
        df_relative_error.to_csv(out_path_relative_error, float_format='%.6f')


if __name__ == "__main__":
    main()