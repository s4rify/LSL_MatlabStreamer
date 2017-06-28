function sendUDPSignal(msg)
    mrHandy = '192.168.2.100';
    mrHandyHome =  '192.168.178.30';
    mrLappi = '192.168.2.106';
    ipAddressMrHandy = mrHandy;
    listeningPort = 50006;
    sendingPort = 50006;
    u = udp(ipAddressMrHandy , listeningPort, 'LocalPort', sendingPort );
    fopen(u);
    fwrite(u, msg);
    fclose(u);
end
