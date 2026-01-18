#!/bin/bash

# ===============================
# KUBESENTINEL v1.1
# Kubernetes Access Recon Tool
# ===============================

GREEN="\e[32m"
RED="\e[31m"
CYAN="\e[36m"
YELLOW="\e[33m"
RESET="\e[0m"

CI_MODE=${CI:-false}
NAMESPACE=${NAMESPACE:-tafadzwa-dev}

echo -e "${GREEN}"
echo "======================================"
echo "          K U B E S E N T I N E L"
echo "  Kubernetes Security Recon Tool"
echo "======================================"
echo -e "${RESET}"

# -------------------------------
# 1️⃣ CONTEXT DISCOVERY
# -------------------------------
echo -e "${CYAN}[DISCOVERY] Kubernetes context${RESET}"

CONTEXT=$(kubectl config current-context 2>/dev/null)
USER=$(kubectl config view --minify -o jsonpath='{.contexts[0].context.user}' 2>/dev/null)

echo -e "→ Context: ${YELLOW}${CONTEXT:-unknown}${RESET}"
echo -e "→ User:    ${YELLOW}${USER:-unknown}${RESET}"
echo

# -------------------------------
# 2️⃣ NAMESPACE ACCESS CHECK
# -------------------------------
echo -e "${CYAN}[ACCESS] Namespace reconnaissance:${RESET} ${YELLOW}$NAMESPACE${RESET}"

if kubectl get ns "$NAMESPACE" >/dev/null 2>&1; then
  NS_ACCESS="granted"
  echo -e "${GREEN}Namespace access granted${RESET}"
else
  NS_ACCESS="denied"
  echo -e "${RED}Namespace access denied${RESET}"
fi
echo

# -------------------------------
# 3️⃣ RBAC PROBING (SAFE)
# -------------------------------
echo -e "${CYAN}[SECURITY] RBAC boundary mapping${RESET}"

CAN_GET_PODS=$(kubectl auth can-i get pods -n "$NAMESPACE" 2>/dev/null || echo "no")
CAN_CREATE_DEPLOY=$(kubectl auth can-i create deployments -n "$NAMESPACE" 2>/dev/null || echo "no")
CAN_GET_EVENTS=$(kubectl auth can-i get events -n "$NAMESPACE" 2>/dev/null || echo "no")
CAN_LIST_NS=$(kubectl auth can-i list namespaces 2>/dev/null || echo "no")

echo -e "→ get pods:           $CAN_GET_PODS"
echo -e "→ create deployments: $CAN_CREATE_DEPLOY"
echo -e "→ get events:         $CAN_GET_EVENTS"
echo -e "→ list namespaces:    $CAN_LIST_NS"
echo

# -------------------------------
# 4️⃣ WORKLOAD ENUMERATION
# -------------------------------
echo -e "${CYAN}[OBSERVATION] Deployed resources${RESET}"

if [ "$NS_ACCESS" = "granted" ]; then
  kubectl -n "$NAMESPACE" get deploy,po,svc 2>/dev/null \
    || echo -e "${YELLOW}No resources found in namespace.${RESET}"
else
  echo -e "${YELLOW}Skipped (namespace access denied).${RESET}"
fi
echo

# -------------------------------
# 5️⃣ CLUSTER READINESS
# -------------------------------
echo -e "${CYAN}[CLUSTER] Worker node status${RESET}"

NODE_COUNT=$(kubectl get nodes --no-headers 2>/dev/null | wc -l)

if [ "$NODE_COUNT" -eq 0 ]; then
  echo -e "${YELLOW}⚠ No worker nodes detected${RESET}"
  echo -e "${YELLOW}Pods will remain Pending even if deployed${RESET}"
else
  kubectl get nodes
fi
echo

# -------------------------------
# 6️⃣ EVENT FORENSICS
# -------------------------------
echo -e "${CYAN}[FORENSICS] Recent events${RESET}"

if [ "$NS_ACCESS" = "granted" ]; then
  kubectl -n "$NAMESPACE" get events --sort-by=.lastTimestamp | tail -n 20
else
  echo -e "${YELLOW}Skipped (namespace access denied).${RESET}"
fi
echo

# -------------------------------
# 7️⃣ CI MODE EXIT
# -------------------------------
if [ "$CI_MODE" = "true" ]; then
  echo -e "${GREEN}[CI] KubeSentinel completed${RESET}"
  exit 0
fi

# -------------------------------
# 8️⃣ SUMMARY
# -------------------------------
echo -e "${GREEN}Reconnaissance complete.${RESET}"
echo -e "${GREEN}Kubernetes boundaries mapped.${RESET}"
echo -e "${GREEN}======================================${RESET}"
