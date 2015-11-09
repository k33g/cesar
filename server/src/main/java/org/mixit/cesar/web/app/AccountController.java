package org.mixit.cesar.web.app;

import java.io.IOException;
import javax.servlet.http.HttpServletResponse;

import org.mixit.cesar.model.Tuple;
import org.mixit.cesar.model.security.Account;
import org.mixit.cesar.repository.AccountRepository;
import org.mixit.cesar.service.AbsoluteUrlFactory;
import org.mixit.cesar.service.account.CreateCesarAccountService;
import org.mixit.cesar.service.account.CreateSocialAccountService;
import org.mixit.cesar.service.account.TokenService;
import org.mixit.cesar.service.authentification.AuthenticationInterceptor;
import org.mixit.cesar.service.authentification.CookieService;
import org.mixit.cesar.service.authentification.Credentials;
import org.mixit.cesar.service.authentification.CurrentUser;
import org.mixit.cesar.service.exception.AuthenticationRequiredException;
import org.mixit.cesar.service.exception.ExpiredTokenException;
import org.mixit.cesar.service.exception.InvalidTokenException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

/**
 * Controller used to authenticate users
 */
@RestController
@RequestMapping("/app/account")
public class AccountController {

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private CreateCesarAccountService createCesarAccountService;

    @Autowired
    private CreateSocialAccountService createSocialAccountService;

    @Autowired
    private AbsoluteUrlFactory urlFactory;

    @Autowired
    private TokenService tokenService;

    @Autowired
    private ApplicationContext applicationContext;

    @Autowired
    private CookieService cookieService;

    @RequestMapping(value = "/cesar/{login}")
    @ResponseStatus(HttpStatus.OK)
    public Tuple user(@PathVariable(value = "login") String login) {
        Account account = accountRepository.findByLogin(login);
        return new Tuple().setKey("login").setValue(account == null ? null : account.getLogin());
    }


    /**
     * Create a new account
     *
     * @see AuthenticationInterceptor
     */
    @RequestMapping(value = "/cesar", method = RequestMethod.POST)
    public Credentials user(@RequestBody Account account) {
        return createCesarAccountService.createNormalAccount(account);
    }

    /**
     * Create a new account
     *
     * @see AuthenticationInterceptor
     */
    @RequestMapping(value = "/social", method = RequestMethod.POST)
    public ResponseEntity userSocial(@RequestBody Account account) {
        CurrentUser currentUser = applicationContext.getBean(CurrentUser.class);

        //The user must be connected
        currentUser.getCredentials().orElseThrow(AuthenticationRequiredException::new);
        createSocialAccountService.updateAccount(account, currentUser.getCredentials().get());
        return new ResponseEntity(HttpStatus.OK);
    }

    /**
     * Validates an user account and unlock account
     *
     * @see AuthenticationInterceptor
     */
    @RequestMapping(value = "/valid")
    public void finalizeCreation(@RequestParam String token, HttpServletResponse response) throws IOException {
        try {
            Account account = tokenService.getCredentialsForToken(token);
            cookieService.setCookieInResponse(response, account);
            response.sendRedirect(urlFactory.getBaseUrl() + "/");
        }
        catch (InvalidTokenException e) {
            response.sendRedirect(urlFactory.getBaseUrl() + "/error/INVALID_TOKEN");
        }
        catch (ExpiredTokenException e) {
            response.sendRedirect(urlFactory.getBaseUrl() + "/error/EXPIRED_TOKEN");
        }
    }



}