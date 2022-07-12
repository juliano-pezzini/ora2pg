-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION techone_pck.create_batch ( cd_estabelecimento_p bigint, cd_tipo_lote_p bigint, dt_referencia_p timestamp, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE

					
	nr_lote_contabil_w	lote_contabil.nr_lote_contabil%type;
	
	
BEGIN
	
	CALL Gerar_Lote_Contabil(	cd_estabelecimento_p,
				cd_tipo_lote_p,
				dt_referencia_p,
				nm_usuario_p);
				
	select	max(nr_lote_contabil)
	into STRICT	nr_lote_contabil_w
	from	lote_contabil
	where	cd_tipo_lote_contabil	= cd_tipo_lote_p
	and	nm_usuario		= nm_usuario_p
	and	cd_estabelecimento	= cd_estabelecimento_p;
	
	return nr_lote_contabil_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION techone_pck.create_batch ( cd_estabelecimento_p bigint, cd_tipo_lote_p bigint, dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;