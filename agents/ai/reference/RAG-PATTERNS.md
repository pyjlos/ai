# RAG Implementation Patterns

## Architecture

```
Query → [Embedding] → [Vector Search] → [Re-rank] → [Context Assembly] → [LLM] → Response
                          ↓ hybrid
                     [Keyword Search]
```

## Chunking Strategy

| Document type | Chunk strategy |
|---|---|
| Code | Function/class boundaries; never split mid-function |
| Prose (docs, articles) | 512–1024 tokens with 20% overlap |
| Structured (JSON, tables) | Per-row or per-record; preserve schema in each chunk |
| Long-form (books, reports) | Hierarchical: chapter → section → paragraph |

## Embedding Models

| Use case | Model |
|---|---|
| General English text | `text-embedding-3-small` (OpenAI) — best cost/quality |
| Multilingual | `multilingual-e5-large` |
| Code | `voyage-code-2` (Voyage AI) |
| High accuracy | `text-embedding-3-large` (OpenAI) |

## Hybrid Search

Combine semantic (vector) and lexical (BM25/keyword) search for best recall:

```python
from opensearchpy import OpenSearch

def hybrid_search(query: str, top_k: int = 10) -> list[dict]:
    embedding = get_embedding(query)

    results = client.search(
        index="documents",
        body={
            "query": {
                "hybrid": {
                    "queries": [
                        {"knn": {"embedding": {"vector": embedding, "k": top_k}}},
                        {"match": {"content": {"query": query}}}
                    ]
                }
            },
            "_source": ["id", "content", "metadata"],
            "size": top_k
        }
    )
    return results["hits"]["hits"]
```

## Context Assembly

Assemble retrieved chunks into the prompt with clear delimiters:

```python
def build_rag_prompt(query: str, chunks: list[dict]) -> str:
    context = "\n\n".join([
        f"[Source {i+1}: {chunk['metadata']['source']}]\n{chunk['content']}"
        for i, chunk in enumerate(chunks)
    ])

    return f"""Answer the question using only the provided sources.
If the answer is not in the sources, say "I don't have enough information."

<sources>
{context}
</sources>

Question: {query}"""
```
