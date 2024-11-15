#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <netinet/in.h>
#import <arpa/inet.h>

void printIPAddress(struct ifaddrs *addrs) {
    struct ifaddrs *cursor = addrs;
    char currentIP[INET_ADDRSTRLEN] = {0};  // 存储普通 IP
    char wifiIP[INET_ADDRSTRLEN] = {0};     // 存储 WiFi IP
    char vpnIP[INET_ADDRSTRLEN] = {0};      // 存储 VPN IP
    
    // 遍历所有接口
    while (cursor != NULL) {
        // 只处理 IPv4 地址
        if (cursor->ifa_addr->sa_family == AF_INET) {
            char ip[INET_ADDRSTRLEN];
            struct sockaddr_in *socketAddress = (struct sockaddr_in *)cursor->ifa_addr;
            inet_ntop(AF_INET, &socketAddress->sin_addr, ip, sizeof(ip));
            
            // 根据接口名称判断并存储相应的 IP 地址
            if (strcmp(cursor->ifa_name, "en0") == 0) {
                // Wi-Fi 接口（通常是 en0）
                strncpy(wifiIP, ip, sizeof(wifiIP));
            } else if (strncmp(cursor->ifa_name, "utun", 4) == 0) {
                // VPN 接口（虚拟接口通常以 utun 开头）
                strncpy(vpnIP, ip, sizeof(vpnIP));
            } else if (strlen(currentIP) == 0) {
                // 第一个找到的 IP 地址作为 Current IP
                strncpy(currentIP, ip, sizeof(currentIP));
            }
        }
        cursor = cursor->ifa_next;
    }
    
    // 输出结果，只有在 IP 地址存在时才输出
    if (strlen(currentIP) > 0) {
        printf("IP: %s\n", currentIP);
    }
    if (strlen(wifiIP) > 0) {
        printf("WiFi: %s\n", wifiIP);
    }
    if (strlen(vpnIP) > 0) {
        printf("VPN: %s\n", vpnIP);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        struct ifaddrs *addrs;
        
        // 获取网络接口信息
        if (getifaddrs(&addrs) == 0) {
            printIPAddress(addrs);  // 输出 IP 地址
            freeifaddrs(addrs);
        } else {
            perror("getifaddrs");
        }
    }
    return 0;
}
