# Tree Cutting App Deployment Guide

## 1. Production backend setup

1. Set the `ConnectionStrings__DefaultConnection` environment variable on the production server; do not store the production password in `appsettings.Production.json`.
2. Publish the API:

```powershell
cd "D:\SHREYAS\Projects\SMC Projects\New Projects\Only Forms\tree_cutting\backend\TreeCutting.Api"
dotnet publish -c Release -o C:\Publish\TreeCuttingApi
```

3. Install the .NET 10 Hosting Bundle on the IIS server if it is not already installed.
4. In IIS Manager:
   - Create a new website, for example `treecutting-api`
   - Set the physical path to `C:\Publish\TreeCuttingApi`
   - Bind to `https://api.yourdomain.com` with a valid certificate
   - Use an Application Pool with `No Managed Code`
5. Verify the API is reachable:

```text
https://api.yourdomain.com/api/masters/application-types
```

## 2. Production frontend setup

1. Copy `.env.production.example` to `.env.production` and replace the API domain.
2. Install dependencies and build the frontend:

```powershell
cd "D:\SHREYAS\Projects\SMC Projects\New Projects\Only Forms\tree_cutting\frontend\tree-cutting-app"
copy .env.production.example .env.production
npm install
npm run build
```

3. Run the production server on a local port:

```powershell
npm run start -- --hostname 0.0.0.0 --port 3000
```

4. In IIS, create a site for the frontend, or use a reverse proxy to forward traffic to `http://127.0.0.1:3000`.

## 3. IIS reverse proxy recommendation

The simplest production setup is:

- API site on `https://api.yourdomain.com`
- Frontend on `https://yourdomain.com`
- Frontend requests route to the API via `NEXT_PUBLIC_API_BASE_URL`

Use IIS URL Rewrite + ARR or configure the frontend as a Node app behind IIS.

## 4. Required environment values

### Backend
- SQL Server connection string
- Allowed origin URLs
- HTTPS binding and certificate
- `SmsGateway__Password` environment variable for the ACL SMS gateway
- `SmsGateway__Enabled=true` in environments where submission SMS should be sent
- `SmsGateway__DltTemplateId` must match the approved DLT template
- `SmsGateway__MessageTemplate` must match the approved DLT message and may use `{FullName}` and `{ApplicationNumber}`

### Frontend
- `NEXT_PUBLIC_API_BASE_URL=https://api.yourdomain.com`

## 5. Common issues

- LocalDB is for development only; do not use it in production.
- The old API process may still hold the `.exe` and block rebuilds; stop running `dotnet` processes before republishing.
- Ensure the IIS app pool has access to the published folder and database.

## 6. Quick process for a clean rebuild

```powershell
Get-Process dotnet -ErrorAction SilentlyContinue | Stop-Process -Force
cd "D:\SHREYAS\Projects\SMC Projects\New Projects\Only Forms\tree_cutting\backend\TreeCutting.Api"
dotnet publish -c Release -o C:\Publish\TreeCuttingApi
cd "D:\SHREYAS\Projects\SMC Projects\New Projects\Only Forms\tree_cutting\frontend\tree-cutting-app"
npm install
npm run build
```

> The project is already configured for production-ready environment-based values in the application code.
