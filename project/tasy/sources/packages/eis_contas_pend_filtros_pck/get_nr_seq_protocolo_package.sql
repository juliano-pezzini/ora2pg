-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION eis_contas_pend_filtros_pck.get_nr_seq_protocolo () RETURNS bigint AS $body$
BEGIN
		return current_setting('eis_contas_pend_filtros_pck.nr_seq_protocolo')::protocolo_convenio.nr_seq_protocolo%type;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION eis_contas_pend_filtros_pck.get_nr_seq_protocolo () FROM PUBLIC;
