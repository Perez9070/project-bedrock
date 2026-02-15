def lambda_handler(event, context):
    records = event.get("Records", [])
    for r in records:
        key = r.get("s3", {}).get("object", {}).get("key")
        if key:
            print(f"Image received: {key}")
    return {"status": "ok"}