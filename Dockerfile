# Stage 1: build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["TestDocker.csproj", "./"]
RUN dotnet restore "TestDocker.csproj"
COPY . .
RUN dotnet publish "TestDocker.csproj" -c Release -o /app/publish

# Stage 2: runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "TestDocker.dll"]

# Base image chỉ để chạy (runtime)
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# thiết lập cổng mặc định
EXPOSE 91
 
# Copy bản đã publish vào image
COPY ./publish ./

# Lệnh chạy ứng dụng
ENTRYPOINT ["dotnet", "TestDocker.dll"]
