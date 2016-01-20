%% -*- mode: erlang; tab-width: 4; indent-tabs-mode: 1; st-rulers: [70] -*-
%% vim: ts=4 sw=4 ft=erlang noet
%%%-------------------------------------------------------------------
%%% @author Andrew Bennett <andrew@pixid.com>
%%% @copyright 2014-2016, Andrew Bennett
%%% @doc
%%%
%%% @end
%%% Created :  07 Jan 2016 by Andrew Bennett <andrew@pixid.com>
%%%-------------------------------------------------------------------
-module(jose_jwa_curve25519).

-behaviour(jose_curve25519).

%% jose_curve25519 callbacks
-export([ed25519_keypair/0]).
-export([ed25519_keypair/1]).
-export([ed25519_secret_to_public/1]).
-export([ed25519_sign/2]).
-export([ed25519_verify/3]).
-export([ed25519ph_keypair/0]).
-export([ed25519ph_keypair/1]).
-export([ed25519ph_secret_to_public/1]).
-export([ed25519ph_sign/2]).
-export([ed25519ph_verify/3]).
-export([x25519_keypair/0]).
-export([x25519_keypair/1]).
-export([x25519_secret_to_public/1]).
-export([x25519_shared_secret/2]).

%%====================================================================
%% jose_curve25519 callbacks
%%====================================================================

% Ed25519
ed25519_keypair() ->
	jose_jwa_ed25519:keypair().

ed25519_keypair(Seed)
		when is_binary(Seed) ->
	jose_jwa_ed25519:keypair(Seed).

ed25519_secret_to_public(SecretKey)
		when is_binary(SecretKey) ->
	jose_jwa_ed25519:secret_to_pk(SecretKey).

ed25519_sign(Message, SecretKey)
		when is_binary(Message)
		andalso is_binary(SecretKey) ->
	jose_jwa_ed25519:sign(Message, SecretKey).

ed25519_verify(Signature, Message, PublicKey)
		when is_binary(Signature)
		andalso is_binary(Message)
		andalso is_binary(PublicKey) ->
	try
		jose_jwa_ed25519:verify(Signature, Message, PublicKey)
	catch
		_:_ ->
			false
	end.

% Ed25519ph
ed25519ph_keypair() ->
	jose_jwa_ed25519:keypair().

ed25519ph_keypair(Seed)
		when is_binary(Seed) ->
	jose_jwa_ed25519:keypair(Seed).

ed25519ph_secret_to_public(SecretKey)
		when is_binary(SecretKey) ->
	jose_jwa_ed25519:secret_to_pk(SecretKey).

ed25519ph_sign(Message, SecretKey)
		when is_binary(Message)
		andalso is_binary(SecretKey) ->
	jose_jwa_ed25519:sign_ph(Message, SecretKey).

ed25519ph_verify(Signature, Message, PublicKey)
		when is_binary(Signature)
		andalso is_binary(Message)
		andalso is_binary(PublicKey) ->
	try
		jose_jwa_ed25519:verify_ph(Signature, Message, PublicKey)
	catch
		_:_ ->
			false
	end.

% X25519
x25519_keypair() ->
	jose_jwa_x25519:keypair().

x25519_keypair(Seed)
		when is_binary(Seed) ->
	jose_jwa_x25519:keypair(Seed).

x25519_secret_to_public(SecretKey)
		when is_binary(SecretKey) ->
	jose_jwa_x25519:sk_to_pk(SecretKey).

x25519_shared_secret(MySecretKey, YourPublicKey)
		when is_binary(MySecretKey)
		andalso is_binary(YourPublicKey) ->
	jose_jwa_x25519:x25519(MySecretKey, YourPublicKey).
