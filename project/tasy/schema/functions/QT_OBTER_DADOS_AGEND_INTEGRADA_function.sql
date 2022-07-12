-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_obter_dados_agend_integrada (nr_seq_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(255);
										
/* 
ie_opcao_p 
A - Descrição da agenda 
H - Horário do agendamento 
*/
										 
										 

BEGIN 
 
if (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') then 
 
	if (ie_opcao_p = 'A') then 
	 
		select	substr(max(obter_nome_medico_combo_agcons(c.cd_estabelecimento, b.cd_agenda, c.cd_tipo_agenda, 'N')),1,255) ds_agenda 
		into STRICT	ds_retorno_w 
		from	agenda_integrada_item a, 
				agenda_consulta b, 
				agenda c 
		where	a.nr_seq_agenda_cons = b.nr_sequencia 
		and		b.cd_agenda = c.cd_agenda 
		and		c.cd_tipo_agenda = 3 
		and		a.nr_seq_atendimento = nr_seq_atendimento_p 
		and		b.ie_status_agenda <> 'C' 
		order by ds_agenda;
	 
	else 
		 
		select	to_char(max(b.dt_agenda), 'dd/mm/yyyy hh24:mi:ss') dt_agenda				 
		into STRICT	ds_retorno_w 
		from	agenda_integrada_item a, 
				agenda_consulta b, 
				agenda c 
		where	a.nr_seq_agenda_cons = b.nr_sequencia 
		and		b.cd_agenda = c.cd_agenda 
		and		c.cd_tipo_agenda = 3 
		and		a.nr_seq_atendimento = nr_seq_atendimento_p 
		and		b.ie_status_agenda <> 'C' 
		order by dt_agenda;
	 
	end if;
 
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_obter_dados_agend_integrada (nr_seq_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;
