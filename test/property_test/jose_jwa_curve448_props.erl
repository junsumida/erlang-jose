%% -*- mode: erlang; tab-width: 4; indent-tabs-mode: 1; st-rulers: [70] -*-
%% vim: ts=4 sw=4 ft=erlang noet
-module(jose_jwa_curve448_props).

-include_lib("public_key/include/public_key.hrl").

-include_lib("triq/include/triq.hrl").

-compile(export_all).

ed448_secret() ->
	binary(57).

ed448_keypair(Secret) ->
	{PK, SK} = jose_curve448:ed448_keypair(Secret),
	{SK, PK}.

ed448ph_secret() ->
	binary(57).

ed448ph_keypair(Secret) ->
	{PK, SK} = jose_curve448:ed448ph_keypair(Secret),
	{SK, PK}.

x448_secret() ->
	binary(56).

x448_keypair(Secret) ->
	{PK, SK} = jose_curve448:x448_keypair(Secret),
	{SK, PK}.

ed448_keypair_gen() ->
	?LET(Secret,
		ed448_secret(),
		ed448_keypair(Secret)).

prop_ed448_secret_to_public() ->
	?FORALL({<< Secret:57/binary, _/binary >>, PK},
		ed448_keypair_gen(),
		begin
			PK =:= jose_jwa_curve448:ed448_secret_to_public(Secret)
		end).

prop_ed448_sign_and_verify() ->
	?FORALL({{SK, PK}, M},
		{ed448_keypair_gen(), binary()},
		begin
			S = jose_jwa_curve448:ed448_sign(M, SK),
			jose_jwa_curve448:ed448_verify(S, M, PK)
		end).

ed448ph_keypair_gen() ->
	?LET(Secret,
		ed448ph_secret(),
		ed448ph_keypair(Secret)).

prop_ed448ph_secret_to_public() ->
	?FORALL({<< Secret:57/binary, _/binary >>, PK},
		ed448ph_keypair_gen(),
		begin
			PK =:= jose_jwa_curve448:ed448ph_secret_to_public(Secret)
		end).

prop_ed448ph_sign_and_verify() ->
	?FORALL({{SK, PK}, M},
		{ed448ph_keypair_gen(), binary()},
		begin
			S = jose_jwa_curve448:ed448ph_sign(M, SK),
			jose_jwa_curve448:ed448ph_verify(S, M, PK)
		end).

x448_keypair_gen() ->
	?LET(Secret,
		x448_secret(),
		x448_keypair(Secret)).

x448_keypairs_gen() ->
	?LET({AliceSecret, BobSecret},
		{x448_secret(), x448_secret()},
		{x448_keypair(AliceSecret), x448_keypair(BobSecret)}).

prop_x448_secret_to_public() ->
	?FORALL({SK, PK},
		x448_keypair_gen(),
		begin
			PK =:= jose_jwa_curve448:x448_secret_to_public(SK)
		end).

prop_x448_shared_secret() ->
	?FORALL({{AliceSK, AlicePK}, {BobSK, BobPK}},
		x448_keypairs_gen(),
		begin
			K = jose_jwa_curve448:x448_shared_secret(AliceSK, BobPK),
			K =:= jose_jwa_curve448:x448_shared_secret(BobSK, AlicePK)
		end).
