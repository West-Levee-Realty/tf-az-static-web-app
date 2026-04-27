# tf-az-static-web-app

Terraform-managed Azure Static Web Apps for West Levee Realty.

## Layout

```
modules/static-web-app/   # reusable SWA + DNS module
sites/<site>/
  terraform/              # per-site infra (own state)
  content/                # static HTML/CSS/JS uploaded after apply
.github/workflows/        # one apply + plan workflow per site
config.json               # source of truth for site parameters
```

## Sites

- **wlvrlt** — `wlvrlt.com` marketing landing ("West Levee Realty<sub>Ai</sub>")

## Targeted deploy

Each site has its own state file (`static-web-app-<site>.tfstate`) and its own
`workflow_dispatch` workflow. To deploy a single site, run that site's workflow.

## Future sites

1. Add a key under `sites` in `config.json`
2. Create `sites/<new>/terraform/main.tf` (copy `sites/wlvrlt/terraform`)
3. Create `sites/<new>/content/`
4. Add `.github/workflows/<new>-apply.yml` and `<new>-plan.yml`

## Custom domains

First apply: `bind_www = true`, `bind_apex = false` (default). After www binding
succeeds, dispatch again with `bind_apex = true` to bind the zone apex.

## Auth (future)

When SSO via Office 365 is needed, flip `sku_size` to `Standard` in
`config.json` and add the `auth.identityProviders.azureActiveDirectory` block to
`sites/<site>/content/staticwebapp.config.json`.

## Costs

| Tier      | Monthly | When                                  |
|-----------|---------|---------------------------------------|
| Free      | $0      | Pre-SSO marketing-only                |
| Standard  | ~$9     | When enterprise auth / B2B chat opens |

## Secret management

All secret access at runtime uses 1Password Connect API on the gpu01 self-hosted runner.
No `op` CLI or service account tokens in pipeline workflows. See repo rules.
