-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sigla_exame_fleury_diag ( nr_prescricao_p bigint, nr_seq_prescr_p bigint ) RETURNS varchar AS $body$
DECLARE


cd_sigla_w		varchar(20) := null;
nr_seq_proc_interno_w	bigint;
cd_estabelecimento_w	prescr_medica.cd_estabelecimento%type;
ie_tipo_atend_w		smallint;
			

BEGIN

select	max(p.nr_seq_proc_interno)	
into STRICT	nr_seq_proc_interno_w
from	prescr_procedimento p,
	proc_interno i
where	p.nr_seq_proc_interno 	= i.nr_sequencia
and	p.nr_prescricao	 	= nr_prescricao_p
and	p.nr_sequencia   	= nr_seq_prescr_p
and	coalesce(p.nr_seq_exame::text, '') = ''
and	i.ie_tipo 		not in ('AP','APH','APC');

if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then

	select	max(coalesce(b.cd_estabelecimento,0)),
			max(coalesce(a.ie_tipo_atendimento,0))
	into STRICT	cd_estabelecimento_w,
			ie_tipo_atend_w	
	from	atendimento_paciente a,
			prescr_medica b
	where	a.nr_atendimento = b.nr_atendimento
	and		b.nr_prescricao = nr_prescricao_p;
	
	select	--max(cd_integracao)
			max(laudo_obter_cd_integracao(nr_prescricao_p, nr_seq_prescr_p, 6))
	into	cd_sigla_w
	from	regra_proc_interno_integra
	where	nr_seq_proc_interno 	= nr_seq_proc_interno_w
	and		coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
	and		coalesce(ie_tipo_atendimento, ie_tipo_atend_w) = ie_tipo_atend_w
	and	ie_tipo_integracao 	= 6;

end if;

return	cd_sigla_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sigla_exame_fleury_diag ( nr_prescricao_p bigint, nr_seq_prescr_p bigint ) FROM PUBLIC;
