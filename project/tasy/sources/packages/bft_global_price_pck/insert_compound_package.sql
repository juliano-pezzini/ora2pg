-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE bft_global_price_pck.insert_compound (cd_composto_p text, ds_composto_p text, nm_usuario_p text) AS $body$
DECLARE

				  
	ora2pg_rowcount int;
compound_matglobal_w	composto_matglobal%rowtype;
	
BEGIN
 	
	update	composto_matglobal
	set	ds_composto		=	ds_composto_p,
		ie_situacao		=	'A',
		dt_atualizacao 		=	clock_timestamp(),
		nm_usuario		=	nm_usuario_p
	where	cd_composto	= cd_composto_p;
	
	GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;

	
	if ( ora2pg_rowcount = 0) then
		compound_matglobal_w.cd_composto		:=	cd_composto_p;
		compound_matglobal_w.ds_composto		:=	ds_composto_p;
		compound_matglobal_w.ie_situacao		:=	'A';
		compound_matglobal_w.dt_atualizacao		:=	clock_timestamp();
		compound_matglobal_w.nm_usuario			:=	nm_usuario_p;
		compound_matglobal_w.dt_atualizacao_nrec	:=	clock_timestamp();	
		compound_matglobal_w.nm_usuario_nrec		:=	nm_usuario_p;
		
		insert into composto_matglobal values (compound_matglobal_w.*);
	end if;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bft_global_price_pck.insert_compound (cd_composto_p text, ds_composto_p text, nm_usuario_p text) FROM PUBLIC;