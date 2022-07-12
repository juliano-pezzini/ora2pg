-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_store_data_mens_pck.set_vl_coparticipacao_gerada ( vl_coparticipacao_p pls_mensalidade_seg_item.vl_item%type) AS $body$
BEGIN
		PERFORM set_config('pls_store_data_mens_pck.vl_coparticipacao_gerada_w', vl_coparticipacao_p, false);
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_store_data_mens_pck.set_vl_coparticipacao_gerada ( vl_coparticipacao_p pls_mensalidade_seg_item.vl_item%type) FROM PUBLIC;