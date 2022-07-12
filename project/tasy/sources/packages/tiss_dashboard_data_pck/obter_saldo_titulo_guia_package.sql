-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tiss_dashboard_data_pck.obter_saldo_titulo_guia (nr_interno_conta_p conta_paciente_guia.nr_interno_conta%type, cd_autorizacao_p conta_paciente_guia.cd_autorizacao%type) RETURNS bigint AS $body$
DECLARE


vl_saldo_titulo_w	titulo_receber.vl_saldo_titulo%type;


BEGIN

	begin
		select	vl_saldo_titulo
		into STRICT	vl_saldo_titulo_w
		from	titulo_receber
		where	nr_titulo = OBTER_TITULO_CONTA_GUIA(nr_interno_conta_p, cd_autorizacao_p, null, null);
	exception
	when others then
		vl_saldo_titulo_w := 0;
	end;


	return coalesce(vl_saldo_titulo_w, 0);

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_dashboard_data_pck.obter_saldo_titulo_guia (nr_interno_conta_p conta_paciente_guia.nr_interno_conta%type, cd_autorizacao_p conta_paciente_guia.cd_autorizacao%type) FROM PUBLIC;