-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pep_obter_pac_maior_prior ( nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE

 
nr_atendimento_w		bigint;
nr_seq_prioridade_w		bigint;
nr_seq_prior_atend_w	bigint;
cd_agenda_w				bigint;
dt_agenda_w				timestamp;
dt_agenda_msg_w			varchar(30);
nm_paciente_w			varchar(255);
ds_inicio_msg_w			varchar(100);
ds_lista_pac_w			varchar(2000);

C01 CURSOR FOR 
	SELECT	a.nr_atendimento, 
			c.nr_seq_prioridade, 
			a.nm_paciente, 
			to_char(a.dt_agenda,'dd/mm/yyyy hh24:mi:ss') 
	from	agenda_consulta_v2 a, 
			atendimento_paciente b, 
			triagem_classif_prioridade c 
	where	a.nr_atendimento = b.nr_atendimento 
	and		b.nr_seq_triagem_prioridade = c.nr_sequencia 
	and		b.ie_nivel_atencao = 'P' 
	and		a.cd_agenda = cd_agenda_w 
	and		trunc(a.dt_agenda) = trunc(dt_agenda_w) 
	and		a.nr_sequencia <> nr_seq_agenda_p 
	and		c.nr_seq_prioridade < nr_seq_prior_atend_w 
	and		a.ie_status_agenda in ('A', 'AA', 'AT', 'AC', 'AP', 'AE', 'AR') 
	order by a.nr_sequencia;


BEGIN 
select	max(a.cd_agenda), 
		max(a.nr_atendimento), 
		max(a.dt_agenda), 
		max(c.nr_seq_prioridade) 
into STRICT	cd_agenda_w, 
		nr_atendimento_w, 
		dt_agenda_w, 
		nr_seq_prior_atend_w 
from	agenda_consulta_v2 a, 
		atendimento_paciente b, 
		triagem_classif_prioridade c 
where	a.nr_atendimento = b.nr_atendimento 
and		b.nr_seq_triagem_prioridade = c.nr_sequencia 
and		b.ie_nivel_atencao = 'P' 
and		a.nr_sequencia = nr_seq_agenda_p;
 
ds_inicio_msg_w := obter_desc_expressao(784132) || chr(10) || chr(13); --'Os seguintes pacientes estão classificados com a urgência superior ao selecionado:' 
open C01;
loop 
fetch C01 into	 
	nr_atendimento_w, 
	nr_seq_prioridade_w, 
	nm_paciente_w, 
	dt_agenda_msg_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	if (coalesce(trim(both ds_lista_pac_w)::text, '') = '') then 
		ds_lista_pac_w := dt_agenda_msg_w || ' - ' || nm_paciente_w;
	else 
		ds_lista_pac_w := ds_lista_pac_w || ', ' || chr(10) || chr(13) || dt_agenda_msg_w || ' - ' || nm_paciente_w;
	end if;
	 
	end;
end loop;
close C01;
 
if ((trim(both ds_lista_pac_w) IS NOT NULL AND (trim(both ds_lista_pac_w))::text <> '')) then 
	return	ds_inicio_msg_w || ds_lista_pac_w;
else 
	return '';
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pep_obter_pac_maior_prior ( nr_seq_agenda_p bigint) FROM PUBLIC;
