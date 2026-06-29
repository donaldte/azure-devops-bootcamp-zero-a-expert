By default, **Argo CD reconciles every 3 minutes (180 seconds)** plus a small random jitter.

If you want it to reconcile every **10 seconds**, you need to modify the `argocd-cm` ConfigMap.

## Step 1: Edit the ConfigMap

```bash
kubectl edit configmap argocd-cm -n argocd
```

Add or modify the `timeout.reconciliation` setting under `data`:

```yaml
data:
  timeout.reconciliation: 10s
```

If the `data:` section already exists, simply add:

```yaml
data:
  timeout.reconciliation: 10s
```

Save and exit.

---

## Step 2: Restart the Argo CD components

Restart the application controller:

```bash
kubectl rollout restart deployment argocd-applicationset-controller -n argocd
```

Restart the API server:

```bash
kubectl rollout restart deployment argocd-server -n argocd
```

Wait until they are ready:

```bash
kubectl get pods -n argocd
```

---

## Step 3: Verify

Run:

```bash
kubectl get configmap argocd-cm -n argocd -o yaml
```

You should see:

```yaml
data:
  timeout.reconciliation: 10s
```

---

## Alternative: Patch it directly

Instead of editing, you can patch the ConfigMap:

```bash
kubectl patch configmap argocd-cm \
  -n argocd \
  --type merge \
  -p '{"data":{"timeout.reconciliation":"10s"}}'
```

Then restart the Argo CD deployments as shown above.

---

### For a CI/CD demo

A **10-second reconciliation** works well for demonstrations because changes appear quickly.

For production, however, it's generally better to keep the default (around **180 seconds**) or use **webhooks** from your Git provider. Webhooks notify Argo CD immediately when changes are pushed, avoiding frequent polling and reducing unnecessary load.
