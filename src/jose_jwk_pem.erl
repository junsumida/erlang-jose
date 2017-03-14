%% -*- mode: erlang; tab-width: 4; indent-tabs-mode: 1; st-rulers: [70] -*-
%% vim: ts=4 sw=4 ft=erlang noet
%%%-------------------------------------------------------------------
%%% @author Andrew Bennett <andrew@pixid.com>
%%% @copyright 2014-2015, Andrew Bennett
%%% @doc
%%%
%%% @end
%%% Created :  24 Jul 2015 by Andrew Bennett <andrew@pixid.com>
%%%-------------------------------------------------------------------
-module(jose_jwk_pem).

-include_lib("public_key/include/public_key.hrl").

%% API
-export([from_binary/1]).
-export([from_binary/2]).
-export([from_certificate/1]).
-export([from_public_key_info/1]).
-export([to_binary/3]).

%%====================================================================
%% API functions
%%====================================================================

from_binary(PEMBinary) when is_binary(PEMBinary) ->
	case public_key:pem_decode(PEMBinary) of
		[CertificatePEMEntry={'Certificate', _, not_encrypted}] ->
			from_certificate(CertificatePEMEntry);
		[PEMEntry] ->
			jose_jwk_kty:from_key(public_key:pem_entry_decode(PEMEntry));
		PEMDecodeError ->
			PEMDecodeError
	end.

from_binary(Password, EncryptedPEMBinary) when is_binary(EncryptedPEMBinary) ->
	case public_key:pem_decode(EncryptedPEMBinary) of
		[EncryptedPEMEntry] ->
			PasswordString = unicode:characters_to_list(Password),
			jose_jwk_kty:from_key(public_key:pem_entry_decode(EncryptedPEMEntry, PasswordString));
		PEMDecodeError ->
			PEMDecodeError
	end.

from_certificate(CertificateBinary) when is_binary(CertificateBinary) ->
	case public_key:pem_decode(CertificateBinary) of
		[CertificatePEMEntry={'Certificate', _, not_encrypted}] ->
			from_certificate(CertificatePEMEntry);
		PEMDecodeError ->
			{error, {pem_decode, PEMDecodeError}}
	end;
from_certificate(CertificatePEMEntry={'Certificate', _, not_encrypted}) ->
	case public_key:pem_entry_decode(CertificatePEMEntry) of
		Certificate=#'Certificate'{} ->
			from_certificate(Certificate);
		PEMEntryDecodeError ->
			{error, {pem_entry_decode, PEMEntryDecodeError}}
	end;
from_certificate(#'Certificate'{tbsCertificate=#'TBSCertificate'{subjectPublicKeyInfo=#'SubjectPublicKeyInfo'{}=SubjectPublicKeyInfo}}) ->
	from_public_key_info(SubjectPublicKeyInfo).

from_public_key_info(#'SubjectPublicKeyInfo'{algorithm=#'AlgorithmIdentifier'{}}=SubjectPublicKeyInfo) ->
	from_public_key_info(public_key:pem_entry_encode('SubjectPublicKeyInfo', SubjectPublicKeyInfo));
from_public_key_info(PEMEntry={'SubjectPublicKeyInfo', DER, not_encrypted}) when is_binary(DER) ->
	jose_jwk_kty:from_key(public_key:pem_entry_decode(PEMEntry)).

to_binary(Password, KeyType, Key) ->
	CipherInfo = {"DES-EDE3-CBC", crypto:strong_rand_bytes(8)},
	PasswordString = binary_to_list(iolist_to_binary(Password)),
	PEMEntry = public_key:pem_entry_encode(KeyType, Key, {CipherInfo, PasswordString}),
	public_key:pem_encode([PEMEntry]).

%%%-------------------------------------------------------------------
%%% Internal functions
%%%-------------------------------------------------------------------
