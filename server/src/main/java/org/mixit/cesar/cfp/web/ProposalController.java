package org.mixit.cesar.cfp.web;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.JsonView;
import org.mixit.cesar.cfp.model.Proposal;
import org.mixit.cesar.cfp.model.ProposalError;
import org.mixit.cesar.cfp.repository.ProposalRepository;
import org.mixit.cesar.cfp.service.ProposalService;
import org.mixit.cesar.security.model.Account;
import org.mixit.cesar.security.repository.AccountRepository;
import org.mixit.cesar.security.service.authentification.CurrentUser;
import org.mixit.cesar.security.service.autorisation.Authenticated;
import org.mixit.cesar.site.model.FlatView;
import org.mixit.cesar.site.model.Tuple;
import org.mixit.cesar.site.service.EventService;
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
 * Controller used to return the parameters used in the CFP
 */
@RestController
@RequestMapping("/app/cfp/proposal")
public class ProposalController {

    @Autowired
    private ProposalRepository proposalRepository;

    @Autowired
    ProposalService proposalService;

    @Autowired
    AccountRepository accountRepository;

    @Autowired
    private EventService eventService;

    @Autowired
    private ApplicationContext applicationContext;

    @RequestMapping()
    @ResponseStatus(HttpStatus.OK)
    @JsonView(FlatView.class)
    public List<Proposal> categories(@RequestParam(required = false) Integer year) {
        return proposalRepository.findAllProposals(eventService.getEvent(year).getId());
    }

    @RequestMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    @JsonView(FlatView.class)
    public Proposal category(@PathVariable(value = "id") Long id) {
        return proposalRepository.findOne(id);
    }

    /**
     * When we create a new user we want to know if a login is already used. This method checks the login
     */
    @RequestMapping(value = "/speakers")
    @ResponseStatus(HttpStatus.OK)
    public List<Tuple> speakers() {

        List<Account> accounts = accountRepository.findPotentialSpeakers();

        //We can have several account for the same person
        return
                accounts
                        .stream()
                        .collect(Collectors.groupingBy(
                                a -> a.getFirstname().concat(" ").concat(a.getLastname()),
                                Collectors.mapping(Account::getId, Collectors.toList())
                        ))
                        .entrySet()
                        .stream()
                        .map(a -> new Tuple().setKey(a.getKey()).setValue(a.getValue().stream().findFirst().get()))
                        .collect(Collectors.toList());
    }


    @RequestMapping(method = RequestMethod.POST)
    @Authenticated
    @JsonView(FlatView.class)
    public ResponseEntity<Proposal> save(@RequestBody Proposal proposal) {
        CurrentUser currentUser = applicationContext.getBean(CurrentUser.class);
        return ResponseEntity.ok().body(proposalService.save(proposal, currentUser.getCredentials().get()));
    }

    @RequestMapping(method = RequestMethod.POST, value = "/check")
    @Authenticated
    public Set<ProposalError> check(@RequestBody Proposal proposal) {
        CurrentUser currentUser = applicationContext.getBean(CurrentUser.class);
        return proposalService.check(proposal);
    }
}