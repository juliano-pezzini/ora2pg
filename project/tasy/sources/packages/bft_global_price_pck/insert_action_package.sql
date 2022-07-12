-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE bft_global_price_pck.insert_action ( cd_acao_p text, ds_acao_p text, nm_usuario_p text) AS $body$
DECLARE

			
	ora2pg_rowcount int;
action_matglobal_w	acao_matglobal%rowtype;
	
	
BEGIN
	
	update	acao_matglobal
	set	ds_acao			=	ds_acao_p,
		dt_atualizacao		= 	clock_timestamp(),
		nm_usuario		= 	nm_usuario_P,
		ie_situacao		=	'A'
	where	cd_acao		= cd_acao_p;
	
	GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;

	
	if ( ora2pg_rowcount = 0) then
		action_matglobal_w.cd_acao			:=	cd_acao_p;
		action_matglobal_w.ds_acao			:=	ds_acao_p;
		action_matglobal_w.ie_situacao			:=	'A';
		action_matglobal_w.dt_atualizacao		:=	clock_timestamp();
		action_matglobal_w.nm_usuario			:=	nm_usuario_p;
		action_matglobal_w.dt_atualizacao_nrec		:=	clock_timestamp();
		action_matglobal_w.nm_usuario_nrec		:=	nm_usuario_p;
		
		
		insert into acao_matglobal values (action_matglobal_w.*);
	end if;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bft_global_price_pck.insert_action ( cd_acao_p text, ds_acao_p text, nm_usuario_p text) FROM PUBLIC;
