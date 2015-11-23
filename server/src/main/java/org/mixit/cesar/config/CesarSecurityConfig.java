package org.mixit.cesar.config;

import javax.servlet.Filter;

import org.mixit.cesar.service.authentification.AuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class CesarSecurityConfig {

    @Bean
    public Filter securityFilter() {
        return new AuthenticationFilter()
                .addPathPatterns(
                        "/app/**/*",
                        "/monitoring/**/*"
                )
                .excludePathPatterns(
                        "/app/login",
                        "/app/login-with/*",
                        "/app/oauth/*",
                        "/app/account/cesar",
                        "/app/account/cesar/*",
                        "/app/account/valid",
                        "/app/account/password");
    }
}
