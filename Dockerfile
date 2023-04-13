FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["test-railway-deploy.csproj", "./"]
RUN dotnet restore "test-railway-deploy.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "test-railway-deploy.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "test-railway-deploy.csproj" --no-restore -c Release -o /app/publish /p:UseAppHost=true

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "test-railway-deploy.dll"]
