-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_vinc_atendimento ( nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
cd_pessoa_fisica_w	varchar(10);
cd_estabelecimento_w	bigint;
nr_seq_retorno_w		bigint;
ds_mensagem_retorno_w	varchar(255);

ds_horario_agendamento_w	varchar(20);
ds_exame_w			varchar(255);
ds_medio_W			varchar(60);


BEGIN 
ds_mensagem_retorno_w := '';
 
select	max(cd_pessoa_fisica), 
	max(cd_estabelecimento) 
into STRICT	cd_pessoa_fisica_w, 
	cd_estabelecimento_w 
from	atendimento_paciente 
where	nr_atendimento = nr_atendimento_p;
 
if (cd_pessoa_fisica_w <> 0) then 
	select	coalesce(max(a.nr_sequencia),0) 
	into STRICT	nr_seq_retorno_w 
	from	agenda_paciente a, 
		agenda b 
	where	a.cd_agenda = b.cd_agenda 
	and	b.cd_tipo_agenda = 1 
	and	a.ie_status_agenda not in ('C', 'B', 'II') 
	and	a.dt_agenda between(clock_timestamp() - interval '1 days') and (clock_timestamp() + interval '1 days') 
	and	coalesce(a.nr_atendimento::text, '') = '' 
	and	a.cd_pessoa_fisica = cd_pessoa_fisica_w 
	and	b.cd_estabelecimento = cd_estabelecimento_w;
end if;
 
if (nr_seq_retorno_w > 0) then 
	 
	Select 	substr(obter_texto_tasy(294630,wheb_usuario_pck.get_nr_seq_idioma) || chr(13) || 
	    obter_texto_dic_objeto(294634, wheb_usuario_pck.get_nr_seq_idioma, 'DT_AGENDAMENTO='||to_char(a.dt_agenda,'dd/mm/yyyy') ||' '|| to_char(a.hr_inicio,'hh24:mi') || 
	    ';CD_PROC='|| CASE WHEN coalesce(coalesce(a.cd_procedimento, a.nr_seq_proc_interno)::text, '') = '' THEN  ''  ELSE chr(13) || substr(obter_exame_agenda(a.cd_procedimento, a.ie_origem_proced, a.nr_seq_proc_interno),1,240) END  || 
	    ';CD_MEDICO='||CASE WHEN coalesce(obter_nome_medico(a.cd_medico,'G')::text, '') = '' THEN  ''  ELSE chr(13) || obter_nome_medico(a.cd_medico,'N') END  || 
	    ';NR_RESERVA='|| CASE WHEN coalesce(a.nr_reserva::text, '') = '' THEN  ''  ELSE a.nr_reserva END ),1,255) 
	into STRICT 	ds_mensagem_retorno_w 
	from 	agenda_paciente a 
	where	a.nr_sequencia = nr_seq_retorno_w;
end if;
 
if (ie_opcao_p = 'C') then 
	return	nr_seq_retorno_w;
else	 
	return	ds_mensagem_retorno_w;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_vinc_atendimento ( nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;
