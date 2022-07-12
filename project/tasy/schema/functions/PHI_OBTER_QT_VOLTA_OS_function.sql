-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION phi_obter_qt_volta_os ( nr_seq_ordem_p bigint) RETURNS bigint AS $body$
DECLARE


qt_volta_w		bigint;
ie_estagio_cliente_w	varchar(255);
ie_entrou_desen_w	varchar(255);

c01 CURSOR FOR
	SELECT
		mose.nr_seq_estagio,
		mep.ie_desenv,
		mep.ie_tecnologia,
		mep.ie_suporte,
		mep.ie_testes,
		mep.ie_aguarda_cliente
	from
		man_ordem_serv_estagio mose,
		man_estagio_processo mep
	where
		mose.nr_seq_ordem = nr_seq_ordem_p
	and	mose.nr_seq_estagio = mep.nr_sequencia
	order by
		mose.dt_atualizacao;
BEGIN
	qt_volta_w := 0;
	ie_estagio_cliente_w := 'N';
	ie_entrou_desen_w := 'N';

	for reg01 in c01 loop
		begin
			if (	ie_entrou_desen_w = 'S'
				and	ie_estagio_cliente_w = 'S'
				and	reg01.ie_desenv = 'S') then
				begin
					ie_estagio_cliente_w := 'N';
					qt_volta_w := qt_volta_w + 1;
				end;
			end if;

			if (reg01.ie_aguarda_cliente = 'S') then
				begin
					ie_estagio_cliente_w := 'S';
				end;
			end if;
			
			if (reg01.ie_desenv = 'S') then
				begin
					ie_entrou_desen_w := 'S';
				end;
			end if;
		end;
	end loop;

return qt_volta_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION phi_obter_qt_volta_os ( nr_seq_ordem_p bigint) FROM PUBLIC;

