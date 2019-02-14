FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["wisconsinweb/wisconsinweb.csproj", "wisconsinweb/"]
RUN dotnet restore "wisconsinweb/wisconsinweb.csproj"
COPY . .
WORKDIR "/src/wisconsinweb"
RUN dotnet build "wisconsinweb.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "wisconsinweb.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "wisconsinweb.dll"]