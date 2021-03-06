package org.mixit.cesar.security.web;

import java.io.IOException;
import java.util.Optional;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mixit.cesar.security.model.Account;
import org.mixit.cesar.security.model.OAuthProvider;
import org.mixit.cesar.security.repository.AccountRepository;
import org.mixit.cesar.site.service.AbsoluteUrlFactory;
import org.mixit.cesar.security.service.account.CreateSocialAccountService;
import org.mixit.cesar.security.service.authentification.CookieService;
import org.mixit.cesar.security.service.oauth.OAuthFactory;
import org.scribe.exceptions.OAuthConnectionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Controller used to authenticate users
 */
@Controller
@Transactional
@RequestMapping("/app")
public class LoginWithSocialAccountController {

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private OAuthFactory oauthFactory;

    @Autowired
    private AbsoluteUrlFactory urlFactory;

    @Autowired
    private CreateSocialAccountService createSocialAccountService;

    @Autowired
    private CookieService cookieService;

    /**
     * Starts the OAuth dance or authenticate user if he has a standard account
     */
    @RequestMapping(value = "/login-with/{provider}", method = RequestMethod.GET)
    public String startOAuthDance(
            @PathVariable("provider") String providerName,
            HttpServletResponse response,
            HttpServletRequest request) throws IOException {
        OAuthProvider provider = toProvider(providerName);
        try {
            return "redirect:" + oauthFactory.create(provider).getRedirectUrl(request);
        }
        catch (OAuthConnectionException exception){
            response.sendRedirect(urlFactory.getBaseUrl() + "/cerror/CONNEXION_REFUSED");
            return null;
        }
    }


    /**
     * Receives the OAuth callback and authenticates, or signs up, the user
     */
    @RequestMapping(value = "/oauth/{provider}", method = RequestMethod.GET)
    public void oauthCallback(@PathVariable("provider") String providerName,
                              HttpServletRequest request,
                              HttpServletResponse response) throws IOException {
        OAuthProvider provider = toProvider(providerName);
        Optional<String> oauthId = oauthFactory.create(provider).getOAuthId(request);
        boolean newAccount = false;

        if (oauthId.isPresent()) {
            Account account = accountRepository.findByOauthProviderAndId(provider, oauthId.get());
            if (account == null) {
                account = createSocialAccountService.createAccount(provider, oauthId.get());
                newAccount = true;
            }

            cookieService.setCookieInResponse(response, account);
            if (newAccount || account.getMember() == null) {
                response.sendRedirect(urlFactory.getBaseUrl() + "/createaccountsocial");
            }
            else {
                response.sendRedirect(urlFactory.getBaseUrl() + "/home");
            }
        }
        else {
            response.sendRedirect(urlFactory.getBaseUrl() + "/cerror/LOGIN_" + providerName);
        }
    }

    private OAuthProvider toProvider(String pathVariable) {
        return OAuthProvider.valueOf(pathVariable.toUpperCase());
    }

}
