import pandas as pd
import numpy as np

import plotly.graph_objs as go
import chart_studio.plotly as py
from plotly.graph_objs import *
from sklearn.decomposition import PCA
import sklearn.cluster as cl
from sklearn import metrics

def scatter_with_color_dimension_graph(features, target, layout_labels):
    ''' Scatter with color dimension graph to visualize the density of the
    Given feature with target
    : param feature :
    : param target :
    : param layout_labels :
    : return :
    '''

    trace1 = go.Scatter(
        y = features,
        mode = 'markers',
        marker = dict(
            size = 6,
            color = target,
            colorscale = 'Viridis',
            showscale = True
        )
    )

    layout = go.Layout(
        title = layout_labels[2],
        xaxis = dict(title = layout_labels [0]), yaxis = dict(title = layout_labels[1])
    )
    data = [trace1]
    fig = Figure(data = data, layout = layout)
    fig.show()

def plot(df, feature):
    features = df[feature]
    targets = df['Type']

    xlabel = 'Data Index'
    ylabel = feature + ' Value'
    graph_title = feature + ' -- Glass Type Density Graph'
    graph_labels = [xlabel, ylabel, graph_title]

    scatter_with_color_dimension_graph(features,
        targets,
    graph_labels)

def main():
    DATASET_PATH = './glass_data_labeled.csv'
    df = pd.read_csv(DATASET_PATH)
        
    print("Correlation Matrix:")
    print(df.loc['0':'213','RI':].corr())

    X = df.loc['0':'213','RI':'Fe']
    Y = df.loc[:, 'Type']

    pca = PCA(n_components=4)
    pca.fit(X)
    X = pca.transform(X)
    
    KM = cl.KMeans(n_clusters=6).fit(X)
    MS = cl.MeanShift().fit(X)
    DB = cl.DBSCAN().fit(X)

    print("K-Means:")
    print(metrics.homogeneity_score(Y, KM.labels_))
    print(metrics.completeness_score(Y, KM.labels_))
    print(metrics.v_measure_score(Y, KM.labels_))
    
    print("Mean Shift:")
    print(metrics.homogeneity_score(Y, MS.labels_))
    print(metrics.completeness_score(Y, MS.labels_))
    print(metrics.v_measure_score(Y, MS.labels_))

    print("DBSCAN:")
    print(metrics.homogeneity_score(Y, DB.labels_))
    print(metrics.completeness_score(Y, DB.labels_))
    print(metrics.v_measure_score(Y, DB.labels_))

if __name__ == "__main__":
    main()
