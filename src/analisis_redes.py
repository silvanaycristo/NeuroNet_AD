from pathlib import Path
import pandas as pd
import networkx as nx

PROJECT_ROOT = Path(__file__).resolve().parents[1]
ruta = PROJECT_ROOT / "aracne_vip"
condiciones = ["Vip_High", "Vip_Intermediate", "Vip_Low", "Vip_Not_AD"]

for cond in condiciones:
    tsv = ruta / cond / "aracne_hvg" / "nobootstrap_network.txt"
    
    df = pd.read_csv(tsv, sep="\t")
    umbral = df["MI"].quantile(0.999)
    df_filtrado = df[df["MI"] >= umbral]
    
    G = nx.from_pandas_edgelist(df_filtrado, source="Regulator", target="Target",
                                 edge_attr="MI", create_using=nx.Graph())

    # Nodo con mayor grado
    degree = dict(G.degree())
    nodo_central = max(degree, key=degree.get)

    # K-core máximo
    kcore_num = nx.core_number(G)
    k_max = max(kcore_num.values())
    kcore_nodes = [n for n, k in kcore_num.items() if k == k_max]
    kcore_subgraph = G.subgraph(kcore_nodes)

    # Mayor grado en k-core
    grados_kcore = dict(kcore_subgraph.degree())
    top_kcore = max(grados_kcore, key=grados_kcore.get)

    print(f"\n=== {cond} ===")
    print(f"Umbral MI (q0.999): {umbral:.6f}")
    print(f"Nodos: {G.number_of_nodes():,}  |  Aristas: {G.number_of_edges():,}")
    print(f"Nodo central (mayor grado): {nodo_central}  (grado {degree[nodo_central]})")
    print(f"K-core máximo: {k_max}  ({len(kcore_nodes)} nodos)")
    print(f"Mayor grado en k-core:      {top_kcore}  (grado {grados_kcore[top_kcore]})")
