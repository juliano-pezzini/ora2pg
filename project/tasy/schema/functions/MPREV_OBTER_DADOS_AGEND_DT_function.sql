-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_dados_agend_dt ( nr_seq_agendamento_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE


/*
FUNCTION criada para substituir a MPREV_OBTER_DADOS_AGENDAMENTO,
permitindo retornar as informações de data no formato correto (DATE)
Implementar opções conforme forem necessárias

IE_OPCAO_P
DT - data agenda
*/
dt_retorno_w		timestamp;


BEGIN

if (nr_seq_agendamento_p IS NOT NULL AND nr_seq_agendamento_p::text <> '') then
	begin

	if (upper(ie_opcao_p) = 'DT') then
		begin

		select	max(dt_agenda)
		into STRICT	dt_retorno_w
		from	mprev_agendamento
		where	nr_sequencia = nr_seq_agendamento_p;

		end;
	end if;

	end;
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_dados_agend_dt ( nr_seq_agendamento_p bigint, ie_opcao_p text) FROM PUBLIC;
