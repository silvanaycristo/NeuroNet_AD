import pandas as pd

genes = pd.read_csv("data/hvg_union.txt", header=None)[0].tolist()
print(f"HVGs en lista: {len(genes)}")

for cond in ["High", "Not_AD", "Intermediate", "Low"]:
    df = pd.read_csv(f"data/Vip_{cond}_metacells.tsv", sep="\t", index_col=0)
    df_filtered = df.loc[df.index.isin(genes)]
    out = f"data/Vip_{cond}_hvg.tsv"
    df_filtered.to_csv(out, sep="\t")
    print(f"{cond}: {len(df)} → {len(df_filtered)} genes → {out}")
