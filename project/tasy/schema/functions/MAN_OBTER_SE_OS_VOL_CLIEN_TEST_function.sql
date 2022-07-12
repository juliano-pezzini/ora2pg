-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_os_vol_clien_test ( nr_seq_ordem_serv_p bigint ) RETURNS varchar AS $body$
DECLARE


dt_cliente_teste_w	timestamp;
dt_estagio_des_w	timestamp;
ie_voltou_cliente_w	varchar(1) := 'N';


BEGIN

	if (nr_seq_ordem_serv_p IS NOT NULL AND nr_seq_ordem_serv_p::text <> '') then

		select	max(a.dt_atualizacao)
		into STRICT	dt_cliente_teste_w
		from	man_ordem_serv_estagio a
		where	a.nr_seq_estagio = 2
		and	a.nr_seq_ordem = nr_seq_ordem_serv_p;

		select	max(a.dt_atualizacao)
		into STRICT	dt_estagio_des_w
		from	man_estagio_processo e,
			man_ordem_serv_estagio a
		where	e.nr_sequencia = a.nr_seq_estagio
		and	e.ie_aguarda_cliente = 'N'
		and	e.ie_desenv = 'S'
		and	a.nr_seq_ordem = nr_seq_ordem_serv_p;

		if (dt_estagio_des_w > dt_cliente_teste_w) then
			ie_voltou_cliente_w := 'S';
		end if;

	end if;

return ie_voltou_cliente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_os_vol_clien_test ( nr_seq_ordem_serv_p bigint ) FROM PUBLIC;

