-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION adep_obter_se_pend_assinat ( nr_sequencia_p bigint, nm_usuario_p text ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1)	:= 'S';
nr_seq_horario_w	pep_item_pendente.nr_seq_horario%type;
ie_tipo_item_adep_w	pep_item_pendente.ie_tipo_item_adep%type;
nr_seq_item_adep_w	pep_item_pendente.nr_seq_item_adep%type;
nr_prescricao_w		pep_item_pendente.nr_prescricao%type;
nr_etapa_adep_w		pep_item_pendente.nr_etapa_adep%type;
nm_usuario_nrec_w	pep_item_pendente.nm_usuario_nrec%type;
nr_atendimento_w	atendimento_paciente.nr_atendimento%type;


BEGIN

select	coalesce(max(nr_seq_horario),0),
		trim(both max(ie_tipo_item_adep)),
		coalesce(max(nr_seq_item_adep),0),
		max(nr_prescricao),
		coalesce(max(nr_etapa_adep),0),
		max(nm_usuario_nrec),
		coalesce(nr_atendimento_w,max(nr_atendimento))
into STRICT	nr_seq_horario_w,
		ie_tipo_item_adep_w,
		nr_seq_item_adep_w,
		nr_prescricao_w,
		nr_etapa_adep_w,
		nm_usuario_nrec_w,
		nr_atendimento_w
from 	pep_item_pendente
where  	nr_sequencia = nr_sequencia_p;

if (ie_tipo_item_adep_w in ('M','MAT','SNE','S','IA','IAG')) then

	select	coalesce(max('S'), 'N')
	into STRICT	ds_retorno_w
	from	prescr_mat_alteracao
	where	nr_prescricao = nr_prescricao_w
	and		nr_seq_horario = nr_seq_horario_w;

elsif (ie_tipo_item_adep_w in ('D','DE')) then

	select	coalesce(max('S'), 'N')
	into STRICT	ds_retorno_w
	from	prescr_mat_alteracao
	where	nr_prescricao = nr_prescricao_w
	and		nr_seq_horario_dieta = nr_seq_horario_w;

elsif (ie_tipo_item_adep_w in ('O')) then

	select 	coalesce(max('S'), 'N')
	into STRICT	ds_retorno_w
	from	prescr_gasoterapia_evento a
	where	a.nr_sequencia in (	SELECT	coalesce(max(b.nr_sequencia),0)
								from	prescr_gasoterapia_evento b
								where	b.nr_seq_gasoterapia = coalesce(nr_seq_item_adep_w,0))
	and		a.nr_seq_gasoterapia = coalesce(nr_seq_item_adep_w,0);

elsif (ie_tipo_item_adep_w in ('P','C','L','G')) then

	select	coalesce(max('S'), 'N')
	into STRICT	ds_retorno_w
	from	prescr_mat_alteracao
	where	nr_prescricao = nr_prescricao_w
	and		nr_seq_horario_proc = nr_seq_horario_w;

elsif (ie_tipo_item_adep_w in ('R')) then

	select	coalesce(max('S'), 'N')
	into STRICT	ds_retorno_w
	from	prescr_mat_alteracao
	where	nr_prescricao = nr_prescricao_w
	and		nr_seq_horario_rec = nr_seq_horario_w;

elsif (ie_tipo_item_adep_w in ('E')) then

	select	coalesce(max('S'), 'N')
	into STRICT	ds_retorno_w
	from	prescr_mat_alteracao
	where	nr_prescricao = nr_prescricao_w
	and		nr_seq_horario_sae = nr_seq_horario_w;

elsif (ie_tipo_item_adep_w in ('B')) then

	select	coalesce(max('S'), 'N')
	into STRICT	ds_retorno_w
	from	prescr_mat_alteracao
	where	nr_prescricao = nr_prescricao_w
	and		nr_seq_horario_ordem = nr_seq_horario_w;

elsif (ie_tipo_item_adep_w in ('SOL','SNE','HM','NPA','NPN','NAN','NPP')) then

	if (ie_tipo_item_adep_w = 'SOL') then

		select 	coalesce(max('S'), 'N')
		into STRICT	ds_retorno_w
		from	prescr_solucao_evento
		where	nr_prescricao = nr_prescricao_w
		and		nr_seq_solucao = nr_seq_item_adep_w
		and		ie_tipo_solucao = 1;

	elsif (ie_tipo_item_adep_w = 'SNE') then

		select 	coalesce(max('S'), 'N')
		into STRICT	ds_retorno_w
		from	prescr_solucao_evento
		where	nr_prescricao = nr_prescricao_w
		and		nr_seq_material = nr_seq_item_adep_w
		and		ie_tipo_solucao = 2;

	elsif (ie_tipo_item_adep_w = 'HM') then

		select 	coalesce(max('S'), 'N')
		into STRICT	ds_retorno_w
		from	prescr_solucao_evento
		where	nr_prescricao = nr_prescricao_w
		and		nr_seq_procedimento = nr_seq_item_adep_w
		and		ie_tipo_solucao = 3;

	elsif (ie_tipo_item_adep_w = 'NPA') then

		select 	coalesce(max('S'), 'N')
		into STRICT	ds_retorno_w
		from	prescr_solucao_evento
		where	nr_prescricao = nr_prescricao_w
		and		nr_seq_nut = nr_seq_item_adep_w
		and		ie_tipo_solucao = 4;

	elsif (ie_tipo_item_adep_w = 'NPN') then

		select 	coalesce(max('S'), 'N')
		into STRICT	ds_retorno_w
		from	prescr_solucao_evento
		where	nr_prescricao = nr_prescricao_w
		and		nr_seq_nut_neo = nr_seq_item_adep_w
		and		ie_tipo_solucao = 5;

	elsif (ie_tipo_item_adep_w = 'NAN') then

		select 	coalesce(max('S'), 'N')
		into STRICT	ds_retorno_w
		from	prescr_solucao_evento
		where	nr_prescricao = nr_prescricao_w
		and		nr_seq_nut_neo = nr_seq_item_adep_w
		and		ie_tipo_solucao = 6;

	elsif (ie_tipo_item_adep_w = 'NPP') then

		select 	coalesce(max('S'), 'N')
		into STRICT	ds_retorno_w
		from	prescr_solucao_evento
		where	nr_prescricao = nr_prescricao_w
		and		nr_seq_nut_neo = nr_seq_item_adep_w
		and		ie_tipo_solucao = 7;

	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_obter_se_pend_assinat ( nr_sequencia_p bigint, nm_usuario_p text ) FROM PUBLIC;
