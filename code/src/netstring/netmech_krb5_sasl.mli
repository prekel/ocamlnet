(* $Id$ *)

module KRB5(GSS:Netsys_gssapi.GSSAPI) : Netsys_sasl_types.SASL_MECHANISM
  (** This is an adapter turning the Kerberos 5 GSSAPI mechanism into
      a SASL mechanism. Note that there are two ways of doing this,
      RFC 4752 and RFC 5801, and this is the former way. The SASL
      name is "GSSAPI". Although this name may suggest that all GSSAPI
      mechanisms are understood, the RFC requires that this protocol
      is only used for Kerberos 5.

      Create the final module like
      {[
module K = Netmech_krb5_sasl.KRB5(Netgss.System)
      ]}

      {b Remarks for clients:}

      This adapter doesn't need any credentials for [create_client_session].
      You can pass the empty list. [user] is ignored (or better, the user
      is taken from the current Kerberos ticket). [authz] can be passed,
      though.

      The client needs to know the service name (e.g. "imap") and the
      fully qualified domain name of the server. These must be passed in
      the "gssapi-acceptor" parameter in the form 
      "service@fully.qualified.domain.name",
      e.g.

      {[
let cs =
  S.create_client_session
    ~user:"" ~authz:""
    ~creds:(S.init_credentials [])
    ~params:[ "gssapi-acceptor", "imap@mailprovider.com", false ]
    ()
      ]}

     {b Remarks for servers:}

     Usually the "realm" parameter is set to the name of the realm.
     In this case the realm is stripped off the principal before the
     [lookup] callback is invoked (e.g. "tim@REALM.NET" is shortened to just
     "tim"). If the "realm" parameter is not set, the full principal
     name is passed to [lookup].

     If [lookup] returns [Some c] for any [c] the user is accepted.
     If it returns [None] the user is declined.

     The "gssapi-acceptor-service" parameter must be set to the name of the 
     service. E.g.

     {[
let ss =
  S.create_server_session
    ~lookup:(fun user _ -> 
              if user_ok user then Some(S.init_credentials []) else None
            )
    ~params:[ "gssapi-acceptor-service", "imap", false;
              "realm", "SAMPLE.NET", false;
            ]
    ()
     ]}

    {b Parameters:}

       - The parameter [mutual] is forwarded to the GSSAPI. Authentication
         fails if mutual authentication cannot be granted.
       - The parameter [secure] is understood but ignored
         (Kerberos is considered as secure method)

   *)
