-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE integracao_contabil_pck.excluir_lote_contabil ( nr_lote_contabil_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


	cd_log_w				bigint;
	ds_erro_w			varchar(255);

	
BEGIN
	begin
	CALL ctb_excluir_lote(nr_lote_contabil_p,nm_usuario_p);
	exception when others then
		ds_erro_w	:= substr('Erro ao excluir o lote: ' || nr_lote_contabil_p ||  ' - ' || sqlerrm(SQLSTATE),1,255);
	end;
	ds_erro_p		:= ds_erro_w;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integracao_contabil_pck.excluir_lote_contabil ( nr_lote_contabil_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
