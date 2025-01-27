(* $Id$ 
 * ----------------------------------------------------------------------
 * Nethttp: Basic definitions for the HTTP protocol
 *)

type protocol_version = 
    int * int
type protocol_attribute =
  [ `Secure_https
  ]
type protocol =
  [ `Http of (protocol_version * protocol_attribute list)
  | `Other
  ]

let string_of_protocol =
  function
    | `Http((m,n),_) -> "HTTP/" ^ string_of_int m ^ "." ^ string_of_int n
    | `Other -> failwith "string_of_protocol"

let http_re = Netstring_str.regexp "HTTP/\\([0-9]+\\)\\.\\([0-9]+\\)$"

let protocol_of_string s =
  match Netstring_str.string_match http_re s 0 with
    | Some m ->
	( try 
	    `Http ((int_of_string (Netstring_str.matched_group m 1 s),
		    int_of_string (Netstring_str.matched_group m 2 s)), [])
	  with
	      Failure _ -> `Other  (* Probably denial-of-service attack! *)
	)
    | None ->
	`Other

type http_status = 
  (* 1xx: (informational) *)
  [ `Continue
  | `Switching_protocols 
  (* 2xx: (successful) *)
  | `Ok
  | `Created
  | `Accepted
  | `Non_authoritative
  | `No_content
  | `Reset_content
  | `Partial_content
  (* 3xx: (redirection) *)
  | `Multiple_choices
  | `Moved_permanently
  | `Found
  | `See_other
  | `Not_modified
  | `Use_proxy
  | `Temporary_redirect
  (* 4xx: (client error) *)
  | `Bad_request
  | `Unauthorized
  | `Payment_required
  | `Forbidden
  | `Not_found
  | `Method_not_allowed
  | `Not_acceptable
  | `Proxy_auth_required
  | `Request_timeout
  | `Conflict
  | `Gone
  | `Length_required
  | `Precondition_failed
  | `Request_entity_too_large
  | `Request_uri_too_long
  | `Unsupported_media_type
  | `Requested_range_not_satisfiable
  | `Expectation_failed
  (* 5xx: (server error) *)
  | `Internal_server_error
  | `Not_implemented
  | `Bad_gateway
  | `Service_unavailable
  | `Gateway_timeout
  | `Http_version_not_supported 
  ]

let int_of_http_status =
  function
      (* 1xx: (informational) *)
    | `Continue -> 100
    | `Switching_protocols -> 101
      (* 2xx: (successful) *)
    | `Ok -> 200
    | `Created -> 201
    | `Accepted -> 202
    | `Non_authoritative -> 203
    | `No_content -> 204
    | `Reset_content -> 205
    | `Partial_content -> 206
      (* 3xx: (redirection) *)
    | `Multiple_choices -> 300
    | `Moved_permanently -> 301
    | `Found -> 302
    | `See_other -> 303
    | `Not_modified -> 304
    | `Use_proxy -> 305
    | `Temporary_redirect -> 307
      (* 4xx: (client error) *)
    | `Bad_request -> 400
    | `Unauthorized -> 401
    | `Payment_required -> 402
    | `Forbidden -> 403
    | `Not_found -> 404
    | `Method_not_allowed -> 405
    | `Not_acceptable -> 406
    | `Proxy_auth_required -> 407
    | `Request_timeout -> 408
    | `Conflict -> 409
    | `Gone -> 410
    | `Length_required -> 411
    | `Precondition_failed -> 412
    | `Request_entity_too_large -> 413
    | `Request_uri_too_long -> 414
    | `Unsupported_media_type -> 415
    | `Requested_range_not_satisfiable -> 416
    | `Expectation_failed -> 417
      (* 5xx: (server error) *)
    | `Internal_server_error -> 500
    | `Not_implemented -> 501
    | `Bad_gateway -> 502
    | `Service_unavailable -> 503
    | `Gateway_timeout -> 504
    | `Http_version_not_supported -> 505


let string_of_http_status =
  function
      (* 1xx: (informational) *)
    | `Continue -> "Continue"
    | `Switching_protocols -> "Switching Protocols"
      (* 2xx: (successful) *)
    | `Ok -> "OK"
    | `Created -> "Created"
    | `Accepted -> "Accepted"
    | `Non_authoritative -> "Non-authoritative Information"
    | `No_content -> "No Content"
    | `Reset_content -> "Reset Content"
    | `Partial_content -> "Partial Content"
      (* 3xx: (redirection) *)
    | `Multiple_choices -> "Multiple Choices"
    | `Moved_permanently -> "Moved Permanently"
    | `Found -> "Found"
    | `See_other -> "See Other"
    | `Not_modified -> "Not Modified"
    | `Use_proxy -> "Use Proxy"
    | `Temporary_redirect -> "Temporary Redirect"
      (* 4xx: (client error) *)
    | `Bad_request -> "Bad Request"
    | `Unauthorized -> "Unauthorized"
    | `Payment_required -> "Payment Required"
    | `Forbidden -> "Forbidden"
    | `Not_found -> "Not Found"
    | `Method_not_allowed -> "Method Not Allowed"
    | `Not_acceptable -> "Not Acceptable"
    | `Proxy_auth_required -> "Proxy Authorization Required"
    | `Request_timeout -> "Request Timeout"
    | `Conflict -> "Conflict"
    | `Gone -> "Gone"
    | `Length_required -> "Length Required"
    | `Precondition_failed -> "Precondition Failed"
    | `Request_entity_too_large -> "Request Entity Too Large"
    | `Request_uri_too_long -> "Request URI Too Long"
    | `Unsupported_media_type -> "Unsupported Media Type"
    | `Requested_range_not_satisfiable -> "Request Range Not Satisfiable"
    | `Expectation_failed -> "Expectation Failed"
      (* 5xx: (server error) *)
    | `Internal_server_error -> "Internal Server Error"
    | `Not_implemented -> "Not Implemented"
    | `Bad_gateway -> "Bad Gateway"
    | `Service_unavailable -> "Service Unavailable"
    | `Gateway_timeout -> "Gateway Timeout"
    | `Http_version_not_supported -> "HTTP Version Not Supported"


let http_status_of_int =
  function
      (* 1xx: (informational) *)
    | 100 -> `Continue
    | 101 -> `Switching_protocols
      (* 2xx: (successful) *)
    | 200 -> `Ok
    | 201 -> `Created
    | 202 -> `Accepted
    | 203 -> `Non_authoritative
    | 204 -> `No_content
    | 205 -> `Reset_content
    | 206 -> `Partial_content
      (* 3xx: (redirection) *)
    | 300 -> `Multiple_choices
    | 301 -> `Moved_permanently
    | 302 -> `Found
    | 303 -> `See_other
    | 304 -> `Not_modified
    | 305 -> `Use_proxy
    | 307 -> `Temporary_redirect
      (* 4xx: (client error) *)
    | 400 -> `Bad_request
    | 401 -> `Unauthorized
    | 402 -> `Payment_required
    | 403 -> `Forbidden
    | 404 -> `Not_found
    | 405 -> `Method_not_allowed
    | 406 -> `Not_acceptable
    | 407 -> `Proxy_auth_required
    | 408 -> `Request_timeout
    | 409 -> `Conflict
    | 410 -> `Gone
    | 411 -> `Length_required
    | 412 -> `Precondition_failed
    | 413 -> `Request_entity_too_large
    | 414 -> `Request_uri_too_long
    | 415 -> `Unsupported_media_type
    | 416 -> `Requested_range_not_satisfiable
    | 417 -> `Expectation_failed
      (* 5xx: (server error) *)
    | 500 -> `Internal_server_error
    | 501 -> `Not_implemented
    | 502 -> `Bad_gateway
    | 503 -> `Service_unavailable
    | 504 -> `Gateway_timeout
    | 505 -> `Http_version_not_supported
    | _ -> raise Not_found

let base_code code =
  if code >= 100 && code < 200 then
    100
  else if code >= 200 && code < 300 then
    200
  else if code >= 300 && code < 400 then
    300
  else if code >= 400 && code < 500 then
    400
  else
    500

type http_method = string * string
  (** Method name, URI *)

type cache_control_token =
    [ `No_store
    | `Max_age of int
    | `Max_stale of int option
    | `Min_fresh of int
    | `No_transform
    | `Only_if_cached
    | `Public
    | `Private of string list
    | `No_cache of string list
    | `Must_revalidate
    | `Proxy_revalidate
    | `S_maxage of int
    | `Extension of string * string option
    ]

type etag =
    [ `Weak of string
    | `Strong of string
    ]

let weak_validator_match e1 e2 =
  match (e1,e2) with
    | (`Strong s1, `Strong s2) -> s1 = s2
    | (`Strong s1, `Weak w2) -> s1 = w2
    | (`Weak w1, `Strong s2) -> w1 = s2
    | (`Weak w1, `Weak w2) -> w1 = w2

let strong_validator_match e1 e2 =
  match (e1,e2) with
    | (`Strong s1, `Strong s2) -> s1 = s2
    | _ -> false
  
exception Bad_header_field of string

class type http_header = Netmime.mime_header
class type http_header_ro = Netmime.mime_header_ro
class type http_trailer = Netmime.mime_header
class type http_trailer_ro = Netmime.mime_header_ro


type netscape_cookie =
    { cookie_name : string;
      cookie_value : string;
      cookie_expires : float option;
      cookie_domain : string option;
      cookie_path : string option;
      cookie_secure : bool;
    }

type cookie = netscape_cookie


let status_re =
  Netstring_str.regexp "^\\([0-9]+\\)\\([ \t]+\\(.*\\)\\)?$"

let status_of_cgi_header hdr =
  let (code, phrase) =
    try
      let status = hdr # field "Status" in
      ( match Netstring_str.string_match status_re status 0 with
	  | Some m ->
	      (int_of_string (Netstring_str.matched_group m 1 status),
	       (try Netstring_str.matched_group m 3 status with Not_found -> "")
	      )
	  | None ->
	      failwith "Bad Status response header field"
		(* Don't know what to do *)
      )
    with
	Not_found ->
	  (* Maybe there is a [Location] header: *)
	  ( try
	      let _location = hdr # field "Location" in
	      (302, "Found")
	    with
		Not_found ->
		  (* Default: 200 OK *)
		  (200, "OK")
	  )
  in
  (* Repair [phrase] if empty: *)
  let phrase =
    if phrase = "" then 
      ( try string_of_http_status (http_status_of_int code)
	with Not_found -> "Unknown"
      )
    else
      phrase in
  (code, phrase)
;;


let query_re =
  Netstring_str.regexp "^\\([^?]*\\)\\?\\(.*\\)$"

let decode_query req_uri =
  match Netstring_str.string_match query_re req_uri 0 with
    | Some m ->
	(Netstring_str.matched_group m 1 req_uri,
	 Netstring_str.matched_group m 2 req_uri)
    | None ->
	(req_uri, "")

let host4_re =
  Netstring_str.regexp "\\([^]: \t[]+\\)\\(:\\([0-9]+\\)\\)?$" (* CHECK *)

let host6_re =
  Netstring_str.regexp "\\[\\([^ \t]+\\)\\]\\(:\\([0-9]+\\)\\)?$"

let split_host_port s =
  match Netstring_str.string_match host4_re s 0 with
    | Some m ->
	let host_name = Netstring_str.matched_group m 1 s in
	let host_port =
	  try Some(int_of_string(Netstring_str.matched_group m 3 s))
	  with
	    | Not_found -> None
	in
	(host_name, host_port)
    | None ->
	( match Netstring_str.string_match host6_re s 0 with
	    | Some m ->
		let host_name = Netstring_str.matched_group m 1 s in
		let host_port =
		  try Some(int_of_string(Netstring_str.matched_group m 3 s))
		  with
		    | Not_found -> None
		in
		(host_name, host_port)
	    | None ->
		failwith "Invalid hostname"
	)

let uripath_encode s =
  let l = Neturl.split_path s in
  let l' = List.map (Netencoding.Url.encode ~plus:false) l in
  Neturl.join_path l'

let uripath_decode s =
  let l = Neturl.split_path s in
  let l' = 
    List.map
      (fun u -> 
	 let u' = Netencoding.Url.decode ~plus:false u in
	 if String.contains u' '/' then
	   failwith "Nethttp.uripath_decode";
	 u')
      l in
  Neturl.join_path l'

let rev_split is_cut s =
  (* exported *)
  let rec seek_cut acc i0 i1 =
    if i1 >= String.length s then
      (String.sub s i0 (i1 - i0)) :: acc
    else if is_cut(String.unsafe_get s i1) then
      skip ((String.sub s i0 (i1 - i0)) :: acc) (i1 + 1) (i1 + 1)
    else
      seek_cut acc i0 (i1 + 1)
  and skip acc i0 i1 =
    if i1 >= String.length s then acc
    else if is_cut(String.unsafe_get s i1) then skip acc i0 (i1 + 1)
    else seek_cut acc i1 i1 in
  skip [] 0 0
    

module Cookie = struct
  (* This module has been written by Christophe Troestler.
      For full copyright message see netcgi.ml
   *)

  (* Cookies are chosen to be mutable because they are stored on the
   client -- there is no rollback possible -- and mutability kind of
   reflects that... *)

  type t =  {
    mutable name : string;
    mutable value : string;
    mutable max_age : int option;
    mutable domain : string option;
    mutable path : string option;
    mutable secure : bool;
    mutable comment : string;
    mutable comment_url : string;
    mutable ports : int list option;
  }

  let make ?max_age ?domain ?path ?(secure=false)
      ?(comment="") ?(comment_url="") ?ports name value =
    { name = name;
      value = value;
      max_age = max_age;
      domain = domain;
      path = path;
      secure = secure;
      comment = comment;
      comment_url = comment_url;
      ports = ports;
    }

  (* Old version of cookies *)
  let of_netscape_cookie c =
    { name = c.cookie_name;
      value = c.cookie_value;
      max_age = (match c.cookie_expires with
                 | None -> None
                 | Some t -> Some(truncate(t -. Unix.time())));
      domain = c.cookie_domain;
      path = c.cookie_path;
      secure = c.cookie_secure;
      comment = "";
      comment_url = "";
      ports = None
    }
  let to_netscape_cookie cookie =
    { cookie_name = cookie.name;
      cookie_value = cookie.value;
      cookie_expires = (match cookie.max_age with
                          | None -> None
                          | Some t -> Some(float t +. Unix.time()));
      cookie_domain = cookie.domain;
      cookie_path = cookie.path;
      cookie_secure = cookie.secure;
    }

  let name cookie = cookie.name
  let value cookie = cookie.value
  let max_age cookie = cookie.max_age
  let domain cookie = cookie.domain
  let path cookie = cookie.path
  let secure cookie = cookie.secure
  let comment cookie = cookie.comment
  let comment_url cookie = cookie.comment_url
  let ports cookie = cookie.ports

  let set_value cookie v = cookie.value <- v
  let set_max_age cookie t = cookie.max_age <- t
  let set_domain cookie dom = cookie.domain <- dom
  let set_path cookie s = cookie.path <- s
  let set_secure cookie b = cookie.secure <- b
  let set_comment cookie s = cookie.comment <- s
  let set_comment_url cookie s = cookie.comment_url <- s
  let set_ports cookie p = cookie.ports <- p

  (* Set -------------------------------------------------- *)

  (* Escape '"', '\\',... and surround the string with quotes. *)
  let escape s0 =
    let len = String.length s0 in
    let encoded_length = ref len in
    for i = 0 to len - 1 do
      match String.unsafe_get s0 i with
      | '\"' | '\\' | '\n' | '\r' -> incr encoded_length
      | '\000' .. '\031' -> decr encoded_length (* ignore *)
      | _ -> ()
    done;
    let s = Bytes.create (!encoded_length + 2) in
    Bytes.unsafe_set s 0 '\"';
    let j = ref 1 in
    for i = 0 to len - 1 do
      (match String.unsafe_get s0 i with
      | '\"' | '\\' as c ->
	  Bytes.unsafe_set s !j '\\'; incr j;
	  Bytes.unsafe_set s !j c; incr j
      | '\n' ->
	  Bytes.unsafe_set s !j '\\'; incr j;
	  Bytes.unsafe_set s !j 'n'; incr j
      | '\r' ->
	  Bytes.unsafe_set s !j '\\'; incr j;
	  Bytes.unsafe_set s !j 'r'; incr j
      | '\000' .. '\031' ->
	  () (* Ignore these control chars, useless for comments *)
      | c ->
	  Bytes.unsafe_set s !j c; incr j
      );
    done;
    Bytes.unsafe_set s !j '\"';
    Bytes.unsafe_to_string s

  (* [gen_cookie c] returns a buffer containing an attribute suitable
     for "Set-Cookie" (RFC 2109) and "Set-Cookie2" (RFC 2965).
     which is backward compatible with Netscape spec.  It is the
     minimal denominator. *)
  let gen_cookie c =
    let buf = Buffer.create 128 in
    (* Encode, do not quote, key-val for compatibility with old browsers. *)
    Buffer.add_string buf (Netencoding.Url.encode ~plus:false c.name);
    Buffer.add_string buf "=";
    Buffer.add_string buf (Netencoding.Url.encode ~plus:false c.value);
    Buffer.add_string buf ";Version=1";
    (* FIXME: Although values of Domain and Path can be quoted since
       RFC2109, it seems that browsers do not understand them -- they
       take the quotes as part of the value.  One way to get correct
       headers is to strip [d] and [p] of unsafe chars -- if they have any. *)
    (match c.domain with
     | None -> ()
     | Some d ->
	 Buffer.add_string buf ";Domain=";
	 Buffer.add_string buf d);
    (match c.path with
     | None -> ()
     | Some p ->
	 Buffer.add_string buf ";Path=";
	 Buffer.add_string buf p);
    if c.secure then Buffer.add_string buf ";secure";
    (match c.max_age with
     | None -> ()
     | Some s ->
	 Buffer.add_string buf ";Max-Age=";
	 Buffer.add_string buf (if s > 0 then string_of_int s else "0");
	 (* For compatibility with old browsers: *)
	 Buffer.add_string buf ";Expires=";
	 Buffer.add_string buf
	   (if s > 0 then Netdate.mk_mail_date (Unix.time() +. float s)
	    else "Thu, 1 Jan 1970 00:00:00 GMT");
    );
    if c.comment <> "" then (
      Buffer.add_string buf ";Comment=";
      Buffer.add_string buf (escape c.comment);
    );
    buf


  let set_set_cookie_ct (http_header:#Netmime.mime_header) cookies =
    let add_cookie (c1, c2) c =
      let buf = gen_cookie c in
      (* In any case, we set a "Set-Cookie" header *)
      let c1 = (Buffer.contents buf) :: c1 in
      let c2 =
	if c.comment_url = "" && c.ports = None then c2 else (
	  (* When this is relevant, also set a "Set-Cookie2" header *)
	  if c.comment_url <> "" then (
	    Buffer.add_string buf ";CommentURL=";
	    Buffer.add_string buf (escape c.comment_url));
	  (match c.ports with
	   | None -> ()
	   | Some p ->
	       Buffer.add_string buf ";Port=\"";
	       Buffer.add_string buf (String.concat ","
					(List.map string_of_int p));
	       Buffer.add_string buf "\""
	  );
	  (Buffer.contents buf) :: c2
	) in
      (c1, c2) in
    let cookie, cookie2 = List.fold_left add_cookie ([], []) cookies in
    http_header#update_multiple_field "Set-Cookie"  cookie;
    (* "Set-Cookie2" must come after in order, when they are
       understood, to override the "Set-Cookie". *)
    http_header#update_multiple_field "Set-Cookie2" cookie2


  (* Get -------------------------------------------------- *)

  (* According to RFC 2068:
     	quoted-string  = ( <"> *(qdtext) <"> )
     	qdtext         = <any TEXT except '\"'>
     	quoted-pair    = "\\" CHAR
     As there a no details, we decode the usual escapes and treat
     other "\x" as simply "x". *)
  let unescape_range s low up =
    if low >= up then "" else
      let len = up - low in
      let b = Bytes.create len in
      let rec decode i j =
	if i < len then (
	  match String.unsafe_get s (i+low) with
	  | '\\' ->
	      let i = i + 1 in
	      if i < len then (
		(match String.unsafe_get s (i+low) with
		 | '\"' | '\\' as c -> Bytes.unsafe_set b j c
		 | 'n' -> Bytes.unsafe_set b j '\n'
		 | 'r' -> Bytes.unsafe_set b j '\r'
		 | 't' -> Bytes.unsafe_set b j '\t'
		 | c -> Bytes.unsafe_set b j c
		);
		decode (i + 1) (j + 1)
	      )
	      else j
	  | c ->
	      Bytes.unsafe_set b j c;
	      decode (i + 1) (j + 1)
	)
	else j in
      let j = decode 0 0 in
      Bytes.sub_string b 0 j


  let ports_of_string s =
    let l = rev_split (fun c -> c = ',' || c = ' ') s in
    List.fold_left (fun pl p ->
		      try int_of_string p :: pl with _ -> pl) [] l

 (* Given a new key-val data, update the list of cookies accordingly
     (new cookie or update attributes of the current one). *)
  let add_key_val key value cl =
    if key <> "" && String.unsafe_get key 0 = '$' then
      (* Keys starting with '$' are for control; ignore the ones we do
	 not know about. *)
      (match cl with
       | [] -> []
       | c :: _ ->
	   (if key = "$Path" then c.path <- Some value
	    else if key = "$Domain" then c.domain <- Some value
	    else if key = "$Port" then
	      c.ports <- Some (ports_of_string value));
	   cl
      )
    else make key value :: cl


  let decode_range s start _end = 
    Netencoding.Url.decode ~pos:start ~len:(_end - start) s

  (* The difference between version 0 and version 1 cookies is that
     the latter start with $Version (present 1st or omitted).  Our
     decoding function can handle both versions transparently, so
     $Version is ignored.  In the absence of "=", the string is
     treated as the VALUE. *)

  (* [get_key cs i0 i len] scan the cookie string [cs] and get the
     key-val pairs. keys and values are stripped of heading and
     trailing spaces, except for quoted values. *)
  let rec get_key cs i0 i len cl =
    if i >= len then
      let value = decode_range cs i0 len in
      if value = "" then cl else make "" value :: cl
    else
      match String.unsafe_get cs i with
      | ',' | ';' ->
	  (* No "=", interpret as a value as Mozilla does.  We choose
	     this over MSIE which is reported to return just "n"
	     instead of "n=" when the value is empty.  *)
	  let cl = make "" (decode_range cs i0 i) :: cl in
	  skip_space_before_key cs (i + 1) len cl
      | '=' ->
	  let i1 = i + 1 in
	  skip_value_space cs i1 len (decode_range cs i0 i) cl
      | c ->
	  get_key cs i0 (i + 1) len cl
  and skip_space_before_key cs i len cl =
    if i >= len then cl
    else
      match String.unsafe_get cs i with
      | ' ' | '\t' | '\n' | '\r' -> skip_space_before_key cs (i + 1) len cl
      | _ -> get_key cs i i len cl
  and skip_value_space cs i len key cl =
    if i >= len then add_key_val key "" cl (* no value *)
    else
      match String.unsafe_get cs i with
      | ' ' | '\t' | '\n' | '\r' -> (* skip linear white space *)
	  skip_value_space cs (i + 1) len key cl
      | '\"' ->
	  get_quoted_value cs (i + 1) (i + 1) len key cl
      | _ ->
	  get_value cs i i len key cl
  and get_value cs i0 i len key cl =
    if i >= len then add_key_val key (decode_range cs i0 len) cl
    else
      match String.unsafe_get cs i with
      | ',' | ';' ->
	  let cl = add_key_val key (decode_range cs i0 i) cl in
	  (* Usually there is a space after ';' to skip *)
	  skip_space_before_key cs (i + 1) len cl
      | _ ->
	  get_value cs i0 (i + 1) len key cl
  and get_quoted_value cs i0 i len key cl =
    if i >= len then (* quoted string not closed; try anyway *)
      add_key_val key (unescape_range cs i0 len) cl
    else
      match String.unsafe_get cs i with
      | '\\' -> get_quoted_value cs i0 (i + 2) len key cl
      | '\"' ->
	  let cl = add_key_val key (unescape_range cs i0 i) cl in
	  skip_to_next cs (i + 1) len cl
      | _ -> get_quoted_value cs i0 (i + 1) len key cl
  and skip_to_next cs i len cl =
    if i >= len then cl
    else
      match String.unsafe_get cs i with
      | ',' | ';' -> skip_space_before_key cs (i + 1) len cl
      | _ -> skip_to_next cs (i + 1) len cl



  let get_cookie_ct (http_header:#http_header_ro) =
    let cookies = http_header#multiple_field "Cookie" in
    let cl = List.fold_left
      (fun cl cs -> get_key cs 0 0 (String.length cs) cl) [] cookies in
    (* The order of cookies is important for the Netscape ones since
       "more specific path mapping should be sent before cookies with
       less specific path mappings" -- for those, there will be only a
       single "Cookie" line. *)
    List.rev cl
end


module Header = struct
  open Netmime
  open Netmime_string

  type param_value = [ `V of string | `Q of string ]
  type auth_challenge = string * (string * param_value) list
  type auth_credentials = string * (string * param_value) list

  (* As scanner we use the scanner for mail header fields from Netmime_string. It
   * is very configurable.
   *)

  let std_special_chars =
        [ ','; ';'; '=' ]
	  (* CHECK: Maybe we should add more characters, e.g. '@'. They are not
	   * used in HTTP, and including them here would cause that field values
	   * containing them are rejected. Maybe we want that.
	   *)

  let scan_value ?(specials = std_special_chars) s = 
    let scanner = create_mime_scanner ~specials ~scan_options:[] s in
    Stream.from
      (fun _ ->
	 Some (snd (scan_token scanner)))
	
  (* ---- Parser combinators for stream parsers: ---- *)
 
  let rec parse_comma_separated_list subparser stream =
    (* The [subparser] is required to return its value when it finds a
     * comma (i.e. [Special ','], or when it finds [End]. These tokens
     * must not be swallowed.
     *)
    let expr_opt = subparser stream in
    match expr_opt with
      | Some expr ->
          expr ::
            parse_comma_separated_rest subparser stream
      | None ->
          []

  and parse_comma_separated_rest subparser stream =
    match Stream.peek stream with
      | Some(Special ',') ->
          Stream.junk stream;
          ignore(parse_commas stream);
          parse_comma_separated_list subparser stream
      | _ ->
          []

  and parse_commas stream =
    match Stream.peek stream with
      | Some(Special ',') ->
          Stream.junk stream;
          parse_commas stream
      | _ ->
          ()

  let parse_end stream =
    match Stream.peek stream with
      | Some End -> Stream.junk stream; ()
      | _ -> raise Stream.Failure

  let merge_lists mh fieldparser fieldname =
    let fields = mh # multiple_field fieldname in
    if fields = [] then raise Not_found;
    List.flatten (List.map fieldparser fields)

  let parse_field mh fn_name f_parse fieldname =
    try
      let field = mh # field fieldname in
      f_parse (scan_value field)
    with
      | Stream.Failure
      | Stream.Error _ ->
	  raise (Bad_header_field fn_name)

  let parse_comma_separated_field ?specials mh fn_name f_parse fieldname  =
    let fieldparser field =
      try
        let stream = scan_value ?specials field in
	let r = parse_comma_separated_list f_parse stream in
        parse_end stream;
        r
      with
	| Stream.Failure
	| Stream.Error _ ->
	    raise (Bad_header_field fn_name) in
    merge_lists mh fieldparser fieldname

  (* ----- Common parsers/printer: ---- *)
	      
  let parse_token_list mh fn_name fieldname =
    let parse_token stream =
      match Stream.peek stream with
        | Some (Atom tok) -> Stream.junk stream; Some tok
        | _ -> None in
    parse_comma_separated_field mh fn_name parse_token fieldname

  let parse_token_or_qstring stream =
    match Stream.peek stream with
      | Some(Atom tok) -> Stream.junk stream; tok
      | Some(QString v) -> Stream.junk stream; v
      | _ -> raise Stream.Failure

  let rec parse_eq_suffix stream =
    match Stream.peek stream with
      | Some (Special '=') ->
          Stream.junk stream;
          "=" ^ parse_eq_suffix stream
      | _ ->
          ""
  let parse_token68_or_qstring stream =
    (* token68: see RFC 7235 *)
    match Stream.peek stream with
      | Some(Atom tok) ->
          Stream.junk stream;
          let suff = parse_eq_suffix stream in
          tok ^ suff
      | Some(QString v) -> Stream.junk stream; v
      | _ -> raise Stream.Failure

  let rec parse_params stream =
    match Stream.npeek 3 stream with
      | [ Special ';'; Atom name; Special '=' ] ->
          for k=1 to 3 do Stream.junk stream done;
          let v = parse_token_or_qstring stream in
          (name,v) :: parse_params stream
      | _ ->
          []

  let parse_extended_token_list mh fn_name fieldname =
    (* token [ '=' (token|qstring) ( ';' token '=' (token|qstring) ) * ] *)
    let rec parse_extended_token stream =
      match Stream.peek stream with
        | Some(Atom tok) ->
            Stream.junk stream;
            let extension = parse_equation stream in
            ( match extension with
		| Some (eq_val, params) ->
		    Some (tok, Some eq_val, params)
		| None ->
		    Some (tok, None, [])
	    )
        | _ ->
            None
    and parse_equation stream =
      match Stream.peek stream with
        | Some(Special '=') ->
            Stream.junk stream;
            let v = parse_token_or_qstring stream in
            let params = parse_params stream in
            Some (v, params)
        | _ ->
            None in
    parse_comma_separated_field mh fn_name parse_extended_token fieldname

  let qstring_indicator_re =
    Netstring_str.regexp "[]\\\"()<>@,;:/[?={} \x00-\x1f\x7f]"
      (* Netstring_pcre.regexp "[\\\\\"()<>@,;:/[\\]?={} \\x00-\\x1f\\x7f]" *)
      
  let qstring_re = 
    Netstring_str.regexp "[\\\"]"
      (* Netstring_pcre.regexp "[\\\\\\\"]" *)
      
  let qstring_of_value s =
    (* Returns a qstring *)
      "\"" ^ Netstring_str.global_replace qstring_re "\\\\\\0" s ^ "\""
	(* Escape qstring_re with a backslash *)

  let string_of_value s =
    (* Returns a token or a qstring, depending on the value of [s] *)
    try 
      ignore(Netstring_str.search_forward qstring_indicator_re s 0);
      qstring_of_value s
    with
	Not_found -> s

  let print_param_value p_val =
    match p_val with
      | `Q s -> s
      | `V s -> string_of_value s 

  let string_of_params l =
    if l = [] then
      ""
    else
      ";" ^ 
      String.concat
	";"
	(List.map
	   (fun (n,s) -> 
	      n ^ "=" ^ string_of_value s)
	   l)

  let string_of_extended_token fn_name =
    function
      | (tok, None, []) ->
	  tok
      | (tok, None, _) ->
	  invalid_arg fn_name
      | (tok, Some eq_val, params) ->
	  tok ^ "=" ^ eq_val ^ string_of_params params

  let parse_parameterized_token_list mh fn_name fieldname =
    (* token ( ';' token '=' (token|qstring) ) * *)
    let rec parse_parameterized_token stream =
      match Stream.peek stream with
        | Some (Atom tok) ->
            Stream.junk stream;
            let params = parse_params stream in
            Some(tok, params)
        | _ ->
            None
    in
    parse_comma_separated_field mh fn_name parse_parameterized_token fieldname

  let string_of_parameterized_token (tok, params) =
    tok ^ string_of_params params

  let q_split ( l : (string * (string * string) list) list )  
              : (string * (string * string) list * (string * string) list) list
              =
    (* Find the "q" param, and split [params] at that position *)
    let rec split params =
      match params with
	| [] -> ([], [])
	| ("q", q) :: rest -> ([], params)
	| other :: rest -> 
	    let before, after = split rest in
	    (other :: before), after
    in
    List.map
      (fun (tok, params) ->
	 let before, after = split params in
	 (tok, before, after))
      l

  let q_merge fn_name (tok, params, q_params) =
    if List.mem_assoc "q" params then invalid_arg fn_name;
    ( match q_params with
	| ( "q", _ ) :: _
	| [] ->
	    (tok, (params @ q_params))
	| _ ->
	    invalid_arg fn_name
    )


  let date_of_string fn_name s =
    try
      Netdate.parse_epoch s
    with
	Invalid_argument _ -> 
	  raise(Bad_header_field fn_name)

  let string_of_date f =
    Netdate.format ~fmt:"%a, %d %b %Y %H:%M:%S GMT" (Netdate.create ~zone:0 f)

  let sort_by_q ?(default=1.0) toks_with_params =
    (* Sorts [toks_with_params] such that the highest [q] values come first.
     * Tokens with a [q] value of 0 are removed. Tokens without [q] value
     * are assumed to have the [default] value. This is also done with 
     * unparseable [q] values.
     *)
    List.map
      snd
      (List.stable_sort
	 (fun (q1, tok_param1) (q2, tok_param2) ->
	    Pervasives.compare q2 q1)
	 (List.filter
	    (fun (q, tok_param) ->
	       q > 0.0)
	    (List.map
	       (fun (tok, params) ->
		  try 
		    let q_str = List.assoc "q" params in
		    (float_of_string q_str, (tok, params))
		  with
		    | Not_found -> (default, (tok, params))
		    | Failure _ -> (default, (tok, params))
	       )
	       toks_with_params)))

  let sort_by_q' ?default tok_with_params_and_qparams =
    List.map 
      (fun ((tok, tok_params), q_params) -> (tok, tok_params, q_params))
      (sort_by_q
	 ?default
	 (List.map
	    (fun (tok, tok_params, q_params) -> ((tok, tok_params), q_params))
	    tok_with_params_and_qparams))

  (* ---- The field accessors: ---- *)

  let get_accept mh =
    q_split
      (parse_parameterized_token_list mh "Nethttp.get_accept" "Accept")

  let set_accept mh av =
    let s =
      String.concat ","
      (List.map
	 (fun triple -> 
	    string_of_parameterized_token (q_merge "Nethttp.set_accept" triple))
	 av) in
    mh # update_field "Accept" s

  let best_media_type mh supp =
    let match_mime a b =
      let (main_type, sub_type) = Netmime_string.split_mime_type b
      in
        sub_type = "*" (*Ignore non-wildcard types*) &&
        (main_type = "*" ||
        main_type = (fst (Netmime_string.split_mime_type a)))
    in
    let filter p l =
      List.fold_right
        (fun ((tok, _, _) as e) l -> if p tok then e :: l else l)
        l
        []
    in
    let accept = try get_accept mh with Not_found -> [ "*/*",[],[] ] in
    match
      sort_by_q' (List.flatten (List.map
        (fun t ->
          filter ((=) t) accept
          @
          filter (match_mime t) accept
        )
        supp))
    with
        (tok, params, qparams) :: _ -> (tok, params)
      | [] -> ("", [])

  let get_accept_charset mh =
    parse_parameterized_token_list mh
      "Nethttp.get_accept_charset" "Accept-Charset"

  let set_accept_charset mh l =
    mh # update_field
      "Accept-Charset" 
      (String.concat "," (List.map string_of_parameterized_token l))

  let best_tok_of_list toks supp = 
    let tok =
      List.find
	(fun tok -> tok = "*" || List.mem tok supp)
	toks in
    if tok = "*" then
      List.find (fun tok -> not (List.mem tok toks)) supp
    else
      tok

  let best_charset mh supp =
    try
      let toks_with_params = get_accept_charset mh in  (* or Not_found *)
      (* Special handling of ISO-8859-1: *)
      let toks_with_params' =
	if not(List.mem_assoc "*" toks_with_params) && 
	  not(List.exists
		(fun (tok,_) -> STRING_LOWERCASE tok = "iso-8859-1") 
		toks_with_params) 
	then
	  toks_with_params @ [ "ISO-8859-1", ["q", "1.0"] ]
	else
	  toks_with_params in
      let toks' = List.map fst (sort_by_q toks_with_params') in
      best_tok_of_list toks' supp
    with
	Not_found -> "*"

  let get_accept_encoding mh =
    parse_parameterized_token_list mh
      "Nethttp.get_accept_encoding" "Accept-Encoding"

  let set_accept_encoding mh l =
    mh # update_field
      "Accept-Encoding" 
      (String.concat "," (List.map string_of_parameterized_token l))

  let best_encoding mh supp =
    try
      let toks_with_params = sort_by_q (get_accept_encoding mh) in
      best_tok_of_list (List.map fst toks_with_params) supp
    with
	Not_found -> "identity"

  let get_accept_language mh =
    parse_parameterized_token_list mh
      "Nethttp.get_accept_language" "Accept-Language"

  let set_accept_language mh l =
    mh # update_field
      "Accept-Language" 
      (String.concat "," (List.map string_of_parameterized_token l))

  let get_accept_ranges mh =
    parse_token_list mh "Nethttp.get_accept_ranges" "Accept-Ranges"

  let set_accept_ranges mh toks =
    mh # update_field "Accept-Ranges" (String.concat "," toks)

  let get_age mh =
    try
      float_of_string (mh # field "Age")
    with
	Failure _ -> raise(Bad_header_field "Nethttp.get_age")

  let set_age mh v =
    mh # update_field "Age" (Printf.sprintf "%.0f" v)

  let get_allow mh =
    parse_token_list mh "Nethttp.get_allow" "Allow"

  let set_allow mh toks =
    mh # update_field "Allow" (String.concat "," toks)

  let comma_split_re = Netstring_str.regexp "\\([ \t]*,\\)+[ \t]*"

  let comma_split =
    Netstring_str.split comma_split_re
      
  let parse_opt_eq_token stream =
    match Stream.peek stream with
      | Some(Special '=') ->
          Stream.junk stream;
          ( match Stream.peek stream with
              | Some (Atom v) -> Stream.junk stream; Some v
              | Some (QString v) -> Stream.junk stream; Some v
              | _ -> raise Stream.Failure
          )
      | _ ->
          None

  let parse_cc_directive_1 stream =
    match Stream.npeek 3 stream with
      | (Atom "no-cache") :: _ ->
          Stream.junk stream;
          ( match parse_opt_eq_token stream with
              | None -> `No_cache []
              | Some names -> `No_cache(comma_split names)
          )
      | (Atom "no-store") :: _ ->
          Stream.junk stream;
          `No_store
      | [ Atom "max-age"; Special '='; Atom seconds ] ->
          for k = 1 to 3 do Stream.junk stream done;
          `Max_age(int_of_string seconds)
      | (Atom "max-stale") :: _ ->
          Stream.junk stream;
          ( match parse_opt_eq_token stream with
              | None -> `Max_stale None
              | Some seconds -> `Max_stale(Some(int_of_string seconds))
          )
      | [ Atom "min-fresh"; Special '='; Atom seconds ] ->
          for k = 1 to 3 do Stream.junk stream done;
          `Min_fresh(int_of_string seconds)
      | ( Atom "no-transform") :: _ ->
          Stream.junk stream;
          `No_transform
      | ( Atom "only-if-cached") :: _ ->
          Stream.junk stream;
          `Only_if_cached
      | ( Atom "public") :: _ ->
          Stream.junk stream;
          `Public
      | ( Atom "private") :: _ ->
          ( match parse_opt_eq_token stream with
              | None -> `Private []
              | Some names -> `Private(comma_split names)
          )
      | ( Atom "must-revalidate") :: _ ->
          Stream.junk stream;
          `Must_revalidate
      | ( Atom "proxy-revalidate") :: _ ->
          Stream.junk stream;
          `Proxy_revalidate
      | [ Atom "s-maxage"; Special '='; Atom seconds ] ->
          for k = 1 to 3 do Stream.junk stream done;
          `S_maxage(int_of_string seconds)
      | ( Atom extension ) :: _ ->
          Stream.junk stream;
          let val_opt = parse_opt_eq_token stream in
          `Extension(extension, val_opt)
      | _ ->
          raise Stream.Failure

  let parse_cc_directive stream =
    try
      Some (parse_cc_directive_1 stream)
    with Stream.Failure -> None

  let get_cache_control mh =
    parse_comma_separated_field
      mh "Nethttp.get_cache_control" parse_cc_directive "Cache-Control"

  let set_cache_control mh l =
    let s = 
      String.concat ","
	(List.map
	   (function
	      | `No_store -> "no-store"
	      | `Max_age n -> "max-age=" ^ string_of_int n
	      | `Max_stale None -> "max-stale"
	      | `Max_stale(Some n) -> "max-stale=" ^ string_of_int n
	      | `Min_fresh n -> "min-fresh=" ^ string_of_int n
	      | `No_transform -> "no-transform"
	      | `Only_if_cached -> "only-if-cached"
	      | `Public -> "public"
	      | `Private names -> "private=\"" ^ String.concat "," names ^ "\""
	      | `No_cache [] -> "no-cache"
	      | `No_cache names -> "no-cache=\"" ^ String.concat "," names ^ "\""
	      | `Must_revalidate -> "must-revalidate"
	      | `Proxy_revalidate -> "proxy-revalidate"
	      | `S_maxage n -> "s-maxage=" ^ string_of_int n
	      | `Extension(tok,None) -> tok
	      | `Extension(tok, Some param) -> tok ^ "=" ^ string_of_value param
	   )
	   l) in
    mh # update_field "Cache-Control" s

  let get_connection mh =
    parse_token_list mh "Nethttp.get_connection" "Connection"

  let set_connection mh toks =
    mh # update_field "Connection" (String.concat "," toks)

  let get_content_encoding mh =
    parse_token_list mh "Nethttp.get_content_encoding" "Content-Encoding"

  let set_content_encoding mh toks =
    mh # update_field "Content-Encoding" (String.concat "," toks)

  let get_content_language mh =
    parse_token_list mh "Nethttp.get_content_language" "Content-Language"

  let set_content_language mh toks =
    mh # update_field "Content-Language" (String.concat "," toks)

  let get_content_length mh =
    try
      Int64.of_string (mh # field "Content-Length")
    with
	Failure _ -> raise (Bad_header_field "Nethttp.get_content_length")

  let set_content_length mh n =
    mh # update_field "Content-Length" (Int64.to_string n)

  let get_content_location mh =
    mh # field "Content-Location"

  let set_content_location mh s =
    mh # update_field "Content-Location" s

  let get_content_md5 mh =
    mh # field "Content-MD5"

  let set_content_md5 mh s =
    mh # update_field "Content-MD5" s

  let parse_byte_range_resp_spec stream =
    match Stream.npeek 3 stream with
      | (Special '*') :: _ ->
          Stream.junk stream;
          None
      | [ Atom first; Special '-'; Atom last ] ->
          for k = 1 to 3 do Stream.junk stream done;
          Some(Int64.of_string first, Int64.of_string last)
      | _ ->
          raise Stream.Failure

  let parse_byte_range_resp_length stream =
    match Stream.peek stream with
      | Some (Special '*') -> 
          Stream.junk stream;
	  None
      | Some (Atom length) ->
          Stream.junk stream;
	  Some(Int64.of_string length)
      | _ ->
          raise Stream.Failure

  let parse_content_range_spec stream =
    if Stream.next stream <> Atom "bytes" then raise Stream.Failure;
    let br = parse_byte_range_resp_spec stream in
    if Stream.next stream <> Special '/' then raise Stream.Failure;
    let l = parse_byte_range_resp_length stream in
    if Stream.next stream <> End then raise Stream.Failure;
    `Bytes(br,l)

  let get_content_range mh =
    let s = mh # field "Content-Range" in
    let stream = scan_value ~specials:[ ','; ';'; '='; '*'; '-'; '/' ] s in
    try
      parse_content_range_spec stream 
    with
      | Stream.Failure
      | Stream.Error _
      | Failure _ ->
	  raise (Bad_header_field "Nethttp.get_content_range")

  let set_content_range mh (`Bytes(range_opt,length_opt)) =
    let s = 
      ( match range_opt with
	  | Some (first,last) -> Int64.to_string first ^ "-" ^ Int64.to_string last
	  | None -> "*"
      ) ^ "/" ^ 
      ( match length_opt with
	  | Some length -> Int64.to_string length
	  | None -> "*"
      ) in
    mh # update_field "Content-Range" ("bytes " ^ s)

  let get_content_type mh =
    try
      List.hd
	(parse_parameterized_token_list mh
	   "Nethttp.get_content_type" "Content-Type")
    with
	Failure _ -> raise(Bad_header_field "Nethttp.get_content_type")

  let set_content_type mh (tok,params) =
    mh # update_field
      "Content-Type" 
      (string_of_parameterized_token (tok,params))

  let get_date mh =
    date_of_string "Nethttp.get_date" (mh # field "Date")

  let set_date mh d =
    mh # update_field "Date" (string_of_date d)

  let parse_etag_token stream =
    match Stream.npeek 3 stream with
      | [ Atom "W"; Special '/'; QString e ] ->
          for k = 1 to 3 do Stream.junk stream done;
	  `Weak e
      | (QString e) :: _ ->
          Stream.junk stream;
	  `Strong e
      | _ ->
          raise Stream.Failure

  let parse_etag stream =
    let etag = parse_etag_token stream in
    parse_end stream;
    etag

  let get_etag mh =
    let s = mh # field "ETag" in
    let stream = scan_value ~specials:[ ','; ';'; '='; '/' ] s in
    try parse_etag stream
    with
      | Stream.Failure
      | Stream.Error _
      | Failure _ ->
	  raise (Bad_header_field "Nethttp.get_etag")

  let string_of_etag =
    function
      | `Weak s -> "W/" ^ qstring_of_value s
      | `Strong s -> qstring_of_value s
	  
  let set_etag mh etag =
    mh # update_field "ETag" (string_of_etag etag)

  let get_expect mh =
    parse_extended_token_list mh "Nethttp.get_expect" "Expect"

  let set_expect mh expectation =
    mh # update_field "Expect" 
      (String.concat "," 
	 (List.map (string_of_extended_token "Nethttp.set_expect") expectation))

  let get_expires mh =
    date_of_string "Nethttp.get_expires" (mh # field "Expires")

  let set_expires mh d =
    mh # update_field "Expires" (string_of_date d)

  let get_from mh =
    mh # field "From"

  let set_from mh v =
    mh # update_field "From" v

  let get_host mh =
    let s = mh # field "Host" in
    try
      split_host_port s
    with
      | Failure _ -> raise(Bad_header_field "Nethttp.get_host")

  let set_host mh (host,port_opt) =
    let s = 
      host ^ 
      ( match port_opt with Some p -> ":" ^ string_of_int p | None -> "") in
    mh # update_field "Host" s

  let parse_etag_or_star_tok stream =
    match Stream.peek stream with
      | Some (Special '*') ->
          Stream.junk stream; Some None
      | _ ->
          try 
            Some(Some(parse_etag_token stream))
          with
            | Stream.Failure -> None

  let get_etag_list mh fn_name fieldname =
    let specials = [ ','; ';'; '='; '/'; '*' ] in
    let l =
      parse_comma_separated_field
	~specials mh fn_name parse_etag_or_star_tok fieldname in
    if List.mem None l then
      None
    else
      Some(List.map (function Some e -> e | None -> assert false) l)

  let set_etag_list mh fieldname l_opt =
    let v =
      match l_opt with
	| None -> "*"
	| Some l ->
	    String.concat "," (List.map string_of_etag l) in
    mh # update_field fieldname v

  let get_if_match mh =
    get_etag_list mh "Nethttp.get_if_match" "If-Match"

  let set_if_match mh =
    set_etag_list mh "If-Match"

  let get_if_modified_since mh =
    date_of_string "Nethttp.get_if_modified_since" (mh # field "If-Modified-Since")

  let set_if_modified_since mh d =
    mh # update_field "If-Modified-Since" (string_of_date d)

  let get_if_none_match mh =
    get_etag_list mh "Nethttp.get_if_none_match" "If-None-Match"

  let set_if_none_match mh =
    set_etag_list mh "If-None-Match"

  let get_if_range mh =
    let s = mh # field "If-Range" in
    let stream = scan_value ~specials:[ ','; ';'; '='; '/' ] s in
    try `Etag (parse_etag stream)
    with
      | Stream.Failure
      | Stream.Error _
      | Failure _ ->
	  `Date (date_of_string "Nethttp.get_if_range" s)
  
  let set_if_range mh v =
    let s =
      match v with
	| `Etag e -> string_of_etag e
	| `Date d -> string_of_date d in
    mh # update_field "If-Range" s

  let get_if_unmodified_since mh =
    date_of_string "Nethttp.get_if_unmodified_since" 
      (mh # field "If-Unmodified-Since")

  let set_if_unmodified_since mh d =
    mh # update_field "If-Unmodified-Since" (string_of_date d)

  let get_last_modified mh =
    date_of_string "Nethttp.get_last_modified" (mh # field "Last-Modified")

  let set_last_modified mh d =
    mh # update_field "Last-Modified" (string_of_date d)

  let get_location mh =
    mh # field "Location"

  let set_location mh s =
    mh # update_field "Location" s

  let get_max_forwards mh =
    try
      int_of_string (mh # field "Max-Forwards")
    with
	Failure _ -> raise(Bad_header_field "Nethttp.get_max_forwards")

  let set_max_forwards mh n =
    mh # update_field "Max-Forwards" (string_of_int n)

  let parse_pragma_directive stream =
    match Stream.peek stream with
      | Some (Atom tok) ->
          Stream.junk stream;
          let param_opt = parse_opt_eq_token stream in
          Some (tok, param_opt)
      | _ ->
          None

  let get_pragma mh =
    parse_comma_separated_field
      mh "Nethttp.get_pragma" parse_pragma_directive "Pragma"

  let set_pragma mh l =
    let s =
      String.concat ","
	(List.map 
	   (function
	      | (tok, None) -> tok
	      | (tok, Some param) -> tok ^ "=" ^ string_of_value param)
	   l) in
    mh # update_field "Pragma" s

  let parse_opt_last_pos stream =
    match Stream.peek stream with
      | Some(Atom last) ->
          Stream.junk stream;
          Some(Int64.of_string last)
      | _ ->
          None

  let rec parse_byte_range_spec stream =
    match Stream.npeek 2 stream with
      | [ Atom first; Special '-' ] ->
          Stream.junk stream; 
          Stream.junk stream; 
          let last = parse_opt_last_pos stream in
	  let r = parse_byte_range_spec_rest stream in
	  (Some (Int64.of_string first), last) :: r
      | [ Special '-'; Atom suffix_length ] ->
          Stream.junk stream; 
          Stream.junk stream; 
	  let r = parse_byte_range_spec_rest stream in
	  (None, Some(Int64.of_string suffix_length)) :: r
      | _ ->
	  []

  and parse_byte_range_spec_rest stream =
    match Stream.peek stream with
      | Some (Special ',') ->
          Stream.junk stream;
          parse_commas stream;
          parse_byte_range_spec stream
      | _ -> []

  let parse_ranges_specifier stream =
    if Stream.next stream <> Atom "bytes" then raise Stream.Failure;
    if Stream.next stream <> Special '=' then raise Stream.Failure;
    let r = parse_byte_range_spec stream in
    if Stream.next stream <> End then raise Stream.Failure;
    `Bytes r

  let get_range mh =
    let s = mh # field "Range" in
    let stream = scan_value ~specials:[ ','; ';'; '='; '*'; '-'; '/' ] s in
    try
      parse_ranges_specifier stream
    with
      | Stream.Failure
      | Stream.Error _
      | Failure _ ->
	  raise (Bad_header_field "Nethttp.get_range")

  let set_range mh (`Bytes l) =
    let s =
      "bytes=" ^ 
      String.concat ","
	(List.map
	   (function
	      | (Some first, Some last) ->
		  Int64.to_string first ^ "-" ^ Int64.to_string last
	      | (Some first, None) ->
		  Int64.to_string first ^ "-"
	      | (None, Some last) ->
		  "-" ^ Int64.to_string last
	      | (None, None) ->
		  invalid_arg "Nethttp.set_range")
	   l) in
    mh # update_field "Range" s
	
  let get_referer mh =
    mh # field "Referer"

  let get_referrer = get_referer

  let set_referer mh s =
    mh # update_field "Referer" s

  let set_referrer = set_referer

  let get_retry_after mh =
    let s = mh # field "Retry-After" in
    try
      `Seconds(int_of_string s)
    with
	Failure _ -> `Date(date_of_string "Nethttp.get_retry_after" s)

  let set_retry_after mh v =
    let s =
      match v with
	| `Seconds n -> string_of_int n 
	| `Date d -> string_of_date d in
    mh # update_field "Retry-After" s

  let get_server mh =
    mh # field "Server"

  let set_server mh name =
    mh # update_field "Server" name

  let get_te mh =
    q_split
      (parse_parameterized_token_list mh "Nethttp.get_te" "TE")

  let set_te mh te =
    let s =
      String.concat ","
      (List.map
	 (fun triple -> 
	    string_of_parameterized_token (q_merge "Nethttp.set_te" triple))
	 te) in
    mh # update_field "TE" s

  let get_trailer mh =
    parse_token_list mh "Nethttp.get_trailer" "Trailer"

  let set_trailer mh fields =
    mh # update_field "Trailer" (String.concat "," fields)

  let get_transfer_encoding mh =
    parse_parameterized_token_list mh "Nethttp.get_transfer_encoding" "Transfer-Encoding"

  let set_transfer_encoding mh te =
    let s =
      String.concat ","
      (List.map string_of_parameterized_token te) in
    mh # update_field "Transfer-Encoding" s

  let get_upgrade mh =
    parse_token_list mh "Nethttp.get_upgrade" "Upgrade"

  let set_upgrade mh fields =
    mh # update_field "Upgrade" (String.concat "," fields)

  let get_user_agent mh =
    mh # field "User-Agent"

  let set_user_agent mh s =
    mh # update_field "User-Agent" s

  let get_vary mh =
    let l = parse_token_list mh "Nethttp.get_vary" "Vary" in
    if List.mem "*" l then
      `Star
    else
      `Fields l

  let set_vary mh v =
    let s =
      match v with
	| `Star -> "*"
	| `Fields l -> String.concat "," l in
    mh # update_field "Vary" s


  (* --- Authentication --- *)

  let parse_challenges mh fn_name fieldname =
    let rec parse_auth_params stream =
      match Stream.npeek 2 stream with
        | [ Atom ap_name; Special '=' ] ->
            Stream.junk stream;
            Stream.junk stream;
            let ap_val = parse_token68_or_qstring stream in
            let rest = parse_auth_param_rest stream in
	    (ap_name, ap_val) :: rest
        | _ ->
            raise Stream.Failure

    and parse_auth_param_rest stream =
      match Stream.npeek 3 stream with
	| [ (Special ','); (Atom ap_name); (Special '=') ] ->
            Stream.junk stream;
            Stream.junk stream;
            Stream.junk stream;
            let ap_val = parse_token68_or_qstring stream in
	    let rest = parse_auth_param_rest stream in
	    (ap_name, ap_val) :: rest
	| _ ->
	    []

    and parse_auth_params_negotiate stream =
      match Stream.npeek 1 stream with
        | [ (Atom d1) ] ->
             Stream.junk stream;
             let d2 =
               match Stream.npeek 1 stream with
                 | [ Special '=' ] -> 
                     Stream.junk stream;
                     ( match Stream.npeek 1 stream with
                         | [ Special '=' ] -> 
                             Stream.junk stream;
                             "=="
                         | _ ->
                             "="
                     )
                 | _ -> "" in
             [ "credentials", d1 ^ d2 ]
        | _ ->
             [ "credentials", "" ]

    and parse_challenge stream =
      match Stream.peek stream with
        | Some (Atom auth_scheme) ->
            Stream.junk stream;
            let auth_params =
              match STRING_LOWERCASE auth_scheme with
                | "negotiate" -> 
                     parse_auth_params_negotiate stream
                | _ -> 
                     parse_auth_params stream in
	    Some(auth_scheme, auth_params)
        | _ ->
            None
    in
    parse_comma_separated_field mh fn_name parse_challenge fieldname

  let mk_challenges fields =
    String.concat "," 
      (List.map
	 (fun (auth_name, auth_params) ->
            let pstring =
              match STRING_LOWERCASE auth_name with
                | "negotiate" ->
                     ( match auth_params with
                         | [ "credentials", data ] -> print_param_value data
                         | _ -> ""
                     )
                | _ ->
	             (String.concat
                        ","
		        (List.map
		           (fun (p_name, p_val) ->
                              p_name ^ "=" ^ print_param_value p_val
                           )
		           auth_params
                        )
                     ) in
            auth_name ^ (if pstring <> "" then " " ^ pstring else "")
	 )
	 fields)

  let mark_decoded (n,v) = (n, `V v)

  let mark_params_decoded (mech,params) =
    (mech, List.map mark_decoded params)

  let mark_many_decoded l =
    List.map mark_params_decoded l

  let get_www_authenticate mh =
    mark_many_decoded
      (parse_challenges mh "Nethttp.get_www_authenticate" "WWW-Authenticate")

  let parse_quoted_parameters s =
    let u = "dummy " ^ s in
    let mh = new Netmime.basic_mime_header ["WWW-Authenticate", u ] in
    try
      match get_www_authenticate mh with
        | [] -> []
        | [_, params] ->
            ( List.map
                (fun (n,v) ->
                   match v with
                     | `Q _ -> assert false
                     | `V s -> (n,s)
                )
                params
            )
        | _ -> assert false 
    with
      | Bad_header_field _ -> failwith "parse_quoted_parameters"

  let value_of_param =
    function
    | `V s -> s
    | `Q s ->
        (match parse_quoted_parameters ("x=" ^ s) with
           | [ _, u ] -> u
           | _ -> raise Not_found
        )

  let set_www_authenticate mh fields =
    let mfields = List.map (fun field -> mk_challenges [field]) fields in
    mh # update_multiple_field "WWW-Authenticate" mfields

  let get_proxy_authenticate mh =
    mark_many_decoded
     (parse_challenges mh "Nethttp.get_proxy_authenticate" "Proxy-Authenticate")

  let set_proxy_authenticate mh fields =
    mh # update_field "Proxy-Authenticate" (mk_challenges fields)

  let ws_re = Netstring_str.regexp "[ \t\r\n]+";;

  let rec parse_auth_params stream =
    match Stream.npeek 2 stream with
      | [ Atom ap_name; Special '=' ] ->
          Stream.junk stream;
          Stream.junk stream;
          let ap_val = parse_token68_or_qstring stream in
          let rest = parse_auth_param_rest stream in
          (ap_name, ap_val) :: rest
      | _ ->
          raise Stream.Failure

  and parse_auth_param_rest stream =
    match Stream.npeek 3 stream with
      | [ Special ','; Atom ap_name; Special '=' ] ->
          Stream.junk stream;
          Stream.junk stream;
          Stream.junk stream;
          let ap_val = parse_token68_or_qstring stream in
          let rest = parse_auth_param_rest stream in
          (ap_name, ap_val) :: rest
      | _ ->
          []

  let parse_credentials mh fn_name fieldname =
    let rec parse_creds stream =
      match Stream.peek stream with 
	| Some (Atom auth_name) ->
            Stream.junk stream;
	    let params = parse_auth_params stream in
	    (auth_name, params)
        | _ ->
            raise Stream.Failure in
    (* Basic authentication is a special case! *)
    let v = mh # field fieldname in  (* or Not_found *)
    match Netstring_str.split ws_re v with
      | [ name; creds ] when STRING_LOWERCASE name = "basic" ->
	  (name, ["credentials", creds])
      | [ name; creds ] when STRING_LOWERCASE name = "negotiate" ->
	  (name, ["credentials", creds])
      | _ ->
	  parse_field mh fn_name parse_creds fieldname

  let parse_auth_info mh fn_name fieldname =
    parse_field mh fn_name parse_auth_params fieldname

  let mk_auth_params auth_params =
    String.concat
      ","
      (List.map
         (fun (p_name, p_val) ->
           p_name ^ "=" ^ print_param_value p_val)
         auth_params
      )

  let mk_credentials (auth_name, auth_params) =
    match STRING_LOWERCASE auth_name with
      | "basic"
      | "negotiate" ->
           let creds = 
	     try List.assoc "credentials" auth_params 
	     with Not_found -> 
	       failwith "Nethttp.mk_credentials: credentials not found" in
           auth_name ^ " " ^ print_param_value creds
      | _ ->
          auth_name ^ " " ^ mk_auth_params auth_params

  let get_authorization mh =
    mark_params_decoded
      (parse_credentials mh "Nethttp.get_authorization" "authorization")

  let set_authorization mh v =
    mh # update_field "Authorization" (mk_credentials v)

  let get_proxy_authorization mh = 
    mark_params_decoded
      (parse_credentials
         mh "Nethttp.get_proxy_authorization" "proxy-authorization")

  let set_proxy_authorization mh v = 
    mh # update_field "Proxy-Authorization" (mk_credentials v)

  let get_authentication_info mh =
    parse_auth_info
      mh "Nethttp.get_authentication_infon"
      "authentication-info"
    |> List.map mark_decoded

  let get_proxy_authentication_info mh =
    parse_auth_info
      mh "Nethttp.get_proxy_authentication_infon"
      "proxy-authentication-info"
    |> List.map mark_decoded

  let set_authentication_info mh v =
    mh # update_field "Authentication-Info" (mk_auth_params v)

  let set_proxy_authentication_info mh v =
    mh # update_field "Proxy-Authentication-Info" (mk_auth_params v)

  (* --- Cookies --- *)

  exception No_equation of string

  let split_name_is_value s =
    (* Recognizes a string "name=value" and returns the pair (name,value).
     * If the string has the wrong format, the function will raise
     * No_equation, and the argument of the exception is the unparseable
     * string.
     *)
    try
      let p = String.index s '=' in
      (String.sub s 0 p, String.sub s (p+1) (String.length s - p - 1))
    with
	Not_found ->
          raise(No_equation s)

  let spaces_at_beginning_re = Netstring_str.regexp "^[ \t\r\n]+"
  let spaces_at_end_re = Netstring_str.regexp "[ \t\r\n]+$"

  let strip_spaces s = (* Remove leading and trailing spaces: *)
    Netstring_str.global_replace 
      spaces_at_end_re ""
      (Netstring_str.global_replace 
	 spaces_at_beginning_re "" s)
      
  let split_cookies_re = Netstring_str.regexp "[ \t\r\n]*;[ \t\r\n]*" ;;

  let get_cookie mh =
    let cstrings = mh # multiple_field "Cookie" in
    (* Remove leading and trailing spaces: *)
    let cstrings' = List.map strip_spaces cstrings in
    let partss = List.map
                   (fun cstring ->
                      Netstring_str.split split_cookies_re cstring
                   )
                   cstrings' in
    let parts = List.flatten partss in

    List.map
      (fun part ->
         let n,v =
           try split_name_is_value part
           with No_equation _ -> (part, "")
                (* Because it is reported that MSIE returns just "n" instead
                 * of "n=" when the value v is empty
                 *)
         in
         let n_dec = Netencoding.Url.decode n in
         let v_dec = Netencoding.Url.decode v in
         (n_dec, v_dec)
      )
      parts

  let get_cookie_ct =
    Cookie.get_cookie_ct

  let set_cookie mh l =
    let s =
      String.concat ";"
	(List.map
	   (fun (n,v) -> 
	      Netencoding.Url.encode n ^ "=" ^ Netencoding.Url.encode v)
	   l) in
    mh # update_field "Cookie" s


  let nv_re = Netstring_str.regexp "^\\([^=;]+\\)\\(=\\(.*\\)\\)?$"


  let get_set_cookie_1 s =
    let nv_list =
      List.map
	(fun item ->
	   ( match Netstring_str.string_match nv_re item 0 with
	       | None ->
		   raise(Bad_header_field "Nethttp.Header.get_set_cookie")
	       | Some m ->
		   let name = Netstring_str.matched_group m 1 item in
		   let value = 
		     try Netstring_str.matched_group m 3 item
		     with Not_found -> "" in
		   (name, value)
	   )
	)
	(Netstring_str.split split_cookies_re s)
    in
    match nv_list with
      | (n,v) :: params ->
	  let params = 
	    List.map (fun (n,v) -> (STRING_LOWERCASE n, v)) params in
	  { cookie_name = Netencoding.Url.decode ~plus:false n;
	    cookie_value = Netencoding.Url.decode ~plus:false v;
	    cookie_expires = (try
				let exp_str = List.assoc "expires" params in
				Some(Netdate.since_epoch
				       (Netdate.parse exp_str))
			      with
				| Not_found -> None);
	    cookie_domain = ( try
				Some(List.assoc "domain" params)
			      with
				| Not_found -> None
			    );
	    cookie_path = ( try
			      Some(List.assoc "path" params)
			    with
			      | Not_found -> None
			  );
	    cookie_secure = ( try
				List.mem_assoc "secure" params
			      with
				| Not_found -> false
			    )
	  }
      | _ ->
	  raise(Bad_header_field "Nethttp.Header.get_set_cookie")


  let get_set_cookie mh =
    let fields = mh # multiple_field "Set-Cookie" in
    List.map get_set_cookie_1 fields


  let set_set_cookie mh l =
    let cookie_fields =
      List.map
	(fun c ->
	   let enc_name  = Netencoding.Url.encode ~plus:false c.cookie_name in
	   let enc_value = Netencoding.Url.encode ~plus:false c.cookie_value in
	   enc_name ^ "=" ^ enc_value ^ 
	   ( match c.cookie_expires with
		 None -> ""
	       | Some t -> 
		   ";EXPIRES=" ^ Netdate.mk_usenet_date t
	   ) ^ 
	   (match c.cookie_domain with
		None -> ""
	      | Some d ->
		  ";DOMAIN=" ^ d
	   ) ^
	   (match c.cookie_path with
		None -> ""
	      | Some p ->
		  ";PATH=" ^ p 
	   ) ^
	   if c.cookie_secure then ";SECURE" else ""
	)
	l
    in
    mh # update_multiple_field "Set-cookie" cookie_fields

  let set_set_cookie_ct =
    Cookie.set_set_cookie_ct


end


type transport_layer_id = int

let new_trans_id () =
  Oo.id (object end)

let http_trans_id = new_trans_id()
let https_trans_id = new_trans_id()
let spnego_trans_id = new_trans_id()
let proxy_only_trans_id = new_trans_id()

type match_result =
    [ `Accept of string * string option
    | `Reroute of string * int
    | `Accept_reroute of string * string option * int
    | `Reject
    ]


module type HTTP_CLIENT_MECHANISM =
  sig
    val mechanism_name : string
    val available : unit -> bool
    val restart_supported : bool
    type credentials
    val init_credentials :
          (string * string * (string * string) list) list ->
            credentials
    val client_match : params:(string * string * bool) list -> 
                       Header.auth_challenge ->
                         match_result
    type client_session
    val client_state : client_session -> Netsys_sasl_types.client_state
    val create_client_session :
          user:string ->
          creds:credentials ->
          params:(string * string * bool) list -> 
          unit ->
            client_session
    val client_configure_channel_binding : client_session -> 
                                           Netsys_sasl_types.cb ->
                                             client_session
    val client_restart : params:(string * string * bool) list -> 
                         client_session -> client_session
    val client_process_challenge :
          client_session -> string -> string -> #http_header_ro -> 
          Header.auth_challenge -> client_session
    val client_emit_response :
          client_session -> string -> string -> #http_header_ro ->
          client_session * Header.auth_credentials * (string * string) list
    val client_channel_binding : client_session -> Netsys_sasl_types.cb
    val client_user_name : client_session -> string
    val client_stash_session :
          client_session -> string
    val client_resume_session :
          string -> 
             client_session
    val client_session_id : client_session -> string option
    val client_domain : client_session -> string list
    val client_prop : client_session -> string -> string
    val client_gssapi_props : client_session -> Netsys_gssapi.client_props
  end



let qstring_of_value = Header.qstring_of_value
