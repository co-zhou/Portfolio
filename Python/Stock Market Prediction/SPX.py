import yfinance as yf
import numpy as np
import matplotlib.pyplot as plt
from keras.callbacks import ModelCheckpoint
from keras.layers import Dense, LSTM
from keras.models import Sequential
from keras.optimizers import Adam
from sklearn.preprocessing import MinMaxScaler

# Get SPX data until 'time' ago
# Earliest Date -> Most Recent Date
# Valid 'time' strings: 1d, 5d, 1mo, 3mo, 6mo,
#                              1y, 2y, 5y, 10y, ytd, max
# Return: Dataframe (N rows x 4 columns) with only 'Open', 'High', 'Low', 'Close' columns
def getSPXData(time):
    data = yf.download("^SPX", period=time).loc[:, ['Open', 'High', 'Low', 'Close']]
    return data 

# Split 'precentage' of dataset into training set and the rest to validation set
def splitData(data, percentage=0.8):
    index = int(len(data)*percentage)
    return data[:index], data[index:]

# Produces a list of snapshots of size (timestepSize) to predict the next entry after the timestepSize
# Data: NumPy Matrix
# timestepSize: window size for LSTM
# Outputs X and Y matrices
# Output X shape: (data length - timestepSize, timestepsize, # features)
# X is minmax normalized
# Output Y shape: (data length - timestepSize, # features)
def splitXY(data, timestepSize):
    return np.array([data[i:i+timestepSize] for i in range(len(data) - timestepSize)]), \
           np.array([data[i] for i in range(timestepSize, len(data))])

def getModel(shape):
    model = Sequential([
        LSTM(32, input_shape=shape),
        Dense(4)
    ])

    model.compile(optimizer=Adam(learning_rate = 0.001), loss='mse')
    model.summary()
    return model

# Uses latest n_lookback entries from data to predict the next day n_forecast times
# Appends the prediction to the data to predict the day after
def forecastNDays(n_lookback, n_forecast, model, data):
    for i in range(n_forecast):
        temp = data[-n_lookback:]
        temp = temp.reshape(1, n_lookback, temp.shape[1])
        data = np.append(data, model.predict(temp), axis=0)
    
    return data[-n_forecast:]

def candlestickChart(indices, data, up_color, down_color):
    data = np.hstack((indices[:, np.newaxis], data))
    up = data[data[:, 4] >= data[:, 1]]
    down = data[data[:, 4] < data[:, 1]]

    width = .3
    width2 = .1

    plt.bar(up[:, 0], up[:, 4]-up[:, 1], width, bottom=up[:, 1], color=up_color)
    plt.bar(up[:, 0], up[:, 2]-up[:, 4], width2, bottom=up[:, 4], color=up_color)
    plt.bar(up[:, 0], up[:, 3]-up[:, 1], width2, bottom=up[:, 1], color=up_color)

    plt.bar(down[:, 0], down[:, 4]-down[:, 1], width, bottom=down[:, 1], color=down_color)
    plt.bar(down[:, 0], down[:, 2]-down[:, 1], width2, bottom=down[:, 4], color=down_color)
    plt.bar(down[:, 0], down[:, 3]-down[:, 4], width2, bottom=down[:, 1], color=down_color)

    plt.xticks(rotation=30, ha='right')
    
if __name__ == '__main__':
    timestepSize = 50
    time = "5y"
    batch_size = 32
    scaler = MinMaxScaler(feature_range = (0, 1))
    
    data = scaler.fit_transform(getSPXData(time))
    train, validation = splitData(data)
    train_x, train_y = splitXY(train, timestepSize)
    validation_x, validation_y = splitXY(validation, timestepSize)

    save_path = "weights.hdf5"

    # Save only the weights with the best validation loss
    cp_callback = ModelCheckpoint(filepath=save_path,
                                                       save_weights_only=True,
                                                       save_best_only=True,
                                                        monitor='val_loss',
                                                       verbose=1)

    model = getModel(train_x.shape[1:])

    model.load_weights(save_path)

    history = model.fit(train_x,
                  train_y,
                  epochs=200,
                  batch_size=batch_size,
                  validation_data=(validation_x, validation_y),
                  callbacks=[cp_callback],
                  verbose=2)
    
    model.load_weights(save_path)

    n_forecast = 1

    forecast = forecastNDays(timestepSize, n_forecast, model, data)

    candlestickChart(np.array(range(-(timestepSize - 1), 1)),
                                scaler.inverse_transform(data[-timestepSize:]),
                                'lightgreen',
                                'lightcoral')
    
    candlestickChart(np.array(range(1, n_forecast + 1)),
                                scaler.inverse_transform(forecast),
                                'darkgreen',
                                'darkred')
    
    print(['Open', 'High', 'Low', 'Close'])
    print(scaler.inverse_transform(forecast))
    
    plt.show()
