from __future__ import annotations

import json
import logging
import os
import random
import threading
import uuid
from collections.abc import Iterable
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any

from google.cloud import bigquery
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

app = FastAPI(title="AI Usage Collector", version="1.0.0")
logger = logging.getLogger("ai-usage-collector")
logging.basicConfig(level=os.getenv("LOG_LEVEL", "INFO"))

PROVIDER_MODELS = {
    "openai": ["gpt-4o", "gpt-4.1-mini"],
    "gemini": ["gemini-1.5-pro", "gemini-2.0-flash"],
    "claude": ["claude-3-5-sonnet", "claude-3-haiku"],
    "github-copilot": ["copilot-chat"],
    "cursor": ["cursor-agent"],
    "internal-agent": ["aiopsvista-collector-mock"],
}
TEAM_NAMES = ["platform-team", "sre-team", "data-team", "product", "marketing"]
WORKFLOWS = [
    "incident-analysis",
    "rag-search",
    "customer-support",
    "copilot-assistance",
    "release-automation",
]
STATUS_WEIGHTS = [
    ("success", 0.8),
    ("error", 0.08),
    ("timeout", 0.06),
    ("rate_limited", 0.04),
    ("cancelled", 0.02),
]


@dataclass
class CollectorStats:
    inserted_batches: int = 0
    inserted_records: int = 0
    last_batch_size: int = 0
    last_inserted_at: str | None = None


class GenerateRequest(BaseModel):
    count: int = Field(default=3, ge=1, le=50)
    provider: str | None = Field(default=None, description="Optional provider override.")
    model: str | None = Field(default=None, description="Optional model override.")
    team_name: str | None = Field(default=None, description="Optional team override.")
    workflow_name: str | None = Field(default=None, description="Optional workflow override.")
    status: str | None = Field(default=None, description="Optional status override.")
    environment: str | None = Field(default=None, description="Optional environment override.")
    user_id: str | None = Field(default=None, description="Optional user override.")
    project_id: str | None = Field(default=None, description="Optional project override.")
    agent_name: str | None = Field(default=None, description="Optional agent override.")


class GenerateResponse(BaseModel):
    inserted_records: int
    inserted_batches: int
    sample_records: list[dict]


stats = CollectorStats()
stats_lock = threading.Lock()


def _log_event(level: int, message: str, **fields: Any) -> None:
    payload = {"message": message, **{key: value for key, value in fields.items() if value is not None}}
    logger.log(level, json.dumps(payload, sort_keys=True))


def _validate_required_configuration() -> dict[str, str]:
    project_id = (os.getenv("PROJECT_ID") or os.getenv("GOOGLE_CLOUD_PROJECT") or "").strip()
    dataset_id = (os.getenv("DATASET_ID") or "").strip()
    table_id = (os.getenv("TABLE_ID") or "").strip()

    missing = []
    if not project_id:
        missing.append("PROJECT_ID")
    if not dataset_id:
        missing.append("DATASET_ID")
    if not table_id:
        missing.append("TABLE_ID")

    if missing:
        raise RuntimeError(f"Missing required environment variable(s): {', '.join(missing)}")

    return {
        "project_id": project_id,
        "dataset_id": dataset_id,
        "table_id": table_id,
    }


@app.on_event("startup")
def startup_validation() -> None:
    context = _validate_required_configuration()
    _log_event(logging.INFO, "startup_validation_passed", **context)


def _bigquery_client() -> bigquery.Client:
    project_id = _validate_required_configuration()["project_id"]
    return bigquery.Client(project=project_id)


def _table_ref() -> str:
    runtime = _validate_required_configuration()
    project_id = runtime["project_id"]
    dataset_id = runtime["dataset_id"]
    table_id = runtime["table_id"]
    return f"{project_id}.{dataset_id}.{table_id}"


def _default_batch_size() -> int:
    try:
        return max(1, min(50, int(os.getenv("DEFAULT_BATCH_SIZE", "3"))))
    except ValueError:
        return 3


def _weighted_status() -> str:
    population = [status for status, _ in STATUS_WEIGHTS]
    weights = [weight for _, weight in STATUS_WEIGHTS]
    return random.choices(population=population, weights=weights, k=1)[0]


def _provider_models(provider: str) -> list[str]:
    return PROVIDER_MODELS.get(provider, [f"{provider}-model"])


def _estimate_cost(provider: str, input_tokens: int, output_tokens: int) -> float:
    per_token_rates = {
        "openai": 0.0000025,
        "gemini": 0.0000020,
        "claude": 0.0000030,
        "github-copilot": 0.0000012,
        "cursor": 0.0000012,
        "internal-agent": 0.0000008,
    }
    multiplier = per_token_rates.get(provider, 0.0000020)
    return round((input_tokens + output_tokens) * multiplier, 6)


def _sample_record(overrides: GenerateRequest | None = None) -> dict:
    overrides = overrides or GenerateRequest()
    provider = overrides.provider or random.choice(list(PROVIDER_MODELS))
    model = overrides.model or random.choice(_provider_models(provider))
    team_name = overrides.team_name or random.choice(TEAM_NAMES)
    workflow_name = overrides.workflow_name or random.choice(WORKFLOWS)
    status = overrides.status or _weighted_status()
    environment = overrides.environment or os.getenv("ENVIRONMENT", "dev")
    user_id = overrides.user_id or f"user-{random.randint(1, 999):03d}"
    project_id = overrides.project_id or os.getenv("PROJECT_ID") or "aiopsvista-market-dev"
    agent_name = overrides.agent_name or random.choice(
        ["incident-triage-agent", "support-assistant", "market-intelligence-agent", None]
    )
    request_id = f"req-{uuid.uuid4().hex[:12]}"
    request_count = 1

    input_tokens = random.randint(250, 6000)
    output_tokens = random.randint(100, 2200)
    total_tokens = input_tokens + output_tokens
    latency_ms = random.randint(180, 7200)
    estimated_cost = _estimate_cost(provider, input_tokens, output_tokens)

    if status != "success":
        estimated_cost = round(estimated_cost * random.uniform(0.25, 0.9), 6)

    return {
        "event_timestamp": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "provider": provider,
        "model": model,
        "request_id": request_id,
        "user_id": user_id,
        "project_id": project_id,
        "team_name": team_name,
        "workflow_name": workflow_name,
        "agent_name": agent_name,
        "request_count": request_count,
        "input_tokens": input_tokens,
        "output_tokens": output_tokens,
        "total_tokens": total_tokens,
        "estimated_cost": estimated_cost,
        "latency_ms": latency_ms,
        "status": status,
        "environment": environment,
    }


def _insert_records(records: Iterable[dict]) -> None:
    client = _bigquery_client()
    rows = list(records)
    request_ids = [row.get("request_id") for row in rows]
    _log_event(logging.INFO, "bigquery_insert_attempt", row_count=len(rows), request_ids=request_ids)
    errors = client.insert_rows_json(_table_ref(), rows)
    if errors:
        _log_event(logging.ERROR, "bigquery_insert_failed", row_count=len(rows), request_ids=request_ids, errors=errors)
        raise HTTPException(status_code=502, detail={"message": "BigQuery insert failed", "errors": errors})

    _log_event(logging.INFO, "bigquery_insert_succeeded", row_count=len(rows), request_ids=request_ids)


@app.get("/")
def health() -> dict:
    context = _validate_required_configuration()
    return {
        "status": "ok",
        "service": "ai-usage-collector",
        "dataset": context["dataset_id"],
        "table": context["table_id"],
        "default_batch_size": _default_batch_size(),
    }


@app.get("/healthz")
def healthz() -> dict:
    return health()


@app.get("/readyz")
def readyz() -> dict:
    try:
        context = _validate_required_configuration()
    except RuntimeError as exc:
        _log_event(logging.ERROR, "readiness_validation_failed", error=str(exc))
        raise HTTPException(status_code=503, detail={"message": str(exc)}) from exc

    return {
        "status": "ready",
        **context,
    }


@app.post("/generate", response_model=GenerateResponse)
def generate(request: GenerateRequest) -> GenerateResponse:
    records = [_sample_record(request) for _ in range(request.count)]
    _insert_records(records)

    with stats_lock:
        stats.inserted_batches += 1
        stats.inserted_records += len(records)
        stats.last_batch_size = len(records)
        stats.last_inserted_at = datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")

    _log_event(
        logging.INFO,
        "generate_request_succeeded",
        request_id=records[0]["request_id"] if records else None,
        row_count=len(records),
        provider=records[0]["provider"] if records else None,
        model=records[0]["model"] if records else None,
    )

    return GenerateResponse(
        inserted_records=len(records),
        inserted_batches=stats.inserted_batches,
        sample_records=records,
    )


@app.get("/stats")
def get_stats() -> dict:
    with stats_lock:
        return {
            "service": "ai-usage-collector",
            "inserted_batches": stats.inserted_batches,
            "inserted_records": stats.inserted_records,
            "last_batch_size": stats.last_batch_size,
            "last_inserted_at": stats.last_inserted_at,
            "supported_providers": list(PROVIDER_MODELS),
        }
