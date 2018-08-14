FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY TestAWS/*.csproj ./TestAWS/
RUN dotnet restore

# copy everything else and build app
COPY TestAWS/. ./TestAWS/
WORKDIR /app/TestAWS
RUN dotnet publish -c Release -o out


FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/TestAWS/out ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]