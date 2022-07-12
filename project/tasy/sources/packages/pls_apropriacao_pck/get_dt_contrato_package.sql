-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_apropriacao_pck.get_dt_contrato () RETURNS timestamp AS $body$
BEGIN
	if (current_setting('pls_apropriacao_pck.pls_segurado_w')::pls_segurado%coalesce(rowtype.nr_seq_contrato::text, '') = '') then
		return current_setting('pls_apropriacao_pck.pls_intercambio_w')::pls_intercambio%rowtype.dt_inclusao;
	else
		return current_setting('pls_apropriacao_pck.pls_contrato_w')::pls_contrato%rowtype.dt_contrato;
	end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_apropriacao_pck.get_dt_contrato () FROM PUBLIC;