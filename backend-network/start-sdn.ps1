Write-Host "`n=== SDN PROJECT STARTUP ===" -ForegroundColor Cyan
Set-Location $PSScriptRoot

Write-Host "[1/4] Starting containers..." -ForegroundColor White
docker compose up -d
Start-Sleep 10
docker compose ps

Write-Host "`n[2/4] Starting OVS in switch-ovs-1..." -ForegroundColor Yellow
docker exec -d switch-ovs-1 bash -c "mkdir -p /usr/local/var/run/openvswitch /usr/local/var/log/openvswitch && pkill -9 ovs-vswitchd 2>/dev/null; pkill -9 ovsdb-server 2>/dev/null; sleep 1 && ovsdb-server /etc/openvswitch/conf.db --remote=punix:/usr/local/var/run/openvswitch/db.sock --pidfile --detach --log-file --no-chdir && sleep 1 && ovs-vswitchd unix:/usr/local/var/run/openvswitch/db.sock --pidfile --detach --log-file --no-chdir -m 10 && sleep 2 && export OVS_RUNDIR=/usr/local/var/run/openvswitch && ovs-vsctl set-controller br-int tcp:172.20.0.2:6633"

Write-Host "`n[3/4] Starting OVS in switch-ovs-2..." -ForegroundColor Yellow
docker exec -d switch-ovs-2 bash -c "mkdir -p /usr/local/var/run/openvswitch /usr/local/var/log/openvswitch && pkill -9 ovs-vswitchd 2>/dev/null; pkill -9 ovsdb-server 2>/dev/null; sleep 1 && ovsdb-server /etc/openvswitch.conf.db --remote=punix:/usr/local/var/run/openvswitch/db.sock --pidfile --detach --log-file --no-chdir && sleep 1 && ovs-vswitchd unix:/usr/local/var/run/openvswitch/db.sock --pidfile --detach --log-file --no-chdir -m 10 && sleep 2 && export OVS_RUNDIR=/usr/local/var/run/openvswitch && ovs-vsctl set-controller br-int tcp:172.20.0.2:6633"

Start-Sleep 5

Write-Host "`n[4/4] Verifying connections..." -ForegroundColor Green
Write-Host "`nSwitch 1:" -ForegroundColor Cyan
docker exec switch-ovs-1 bash -c "export OVS_RUNDIR=/usr/local/var/run/openvswitch && ovs-vsctl show" | Select-String "is_connected"
Write-Host "`nSwitch 2:" -ForegroundColor Cyan
docker exec switch-ovs-2 bash -c "export OVS_RUNDIR=/usr/local/var/run/openvswitch && ovs-vsctl show" | Select-String "is_connected"

Write-Host "`nPing test:" -ForegroundColor White
docker exec switch-ovs-1 ping -c 2 172.20.0.11

Write-Host "`n=========================================" -ForegroundColor Magenta
Write-Host "  ✅ SDN PROJECT READY!" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Magenta