-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_se_quest_setor_proc ( nr_seq_proc_interno_p bigint, nr_atendimento_p bigint, nr_seq_rotina_p bigint ) RETURNS varchar AS $body$
DECLARE


nr_seq_exame_w				prescr_procedimento.nr_seq_exame%type;
cd_procedimento_w			proc_interno.ie_origem_proced%type;
ie_origem_proced_w			proc_interno.ie_origem_proced%type;
cd_grupo_proc_w				bigint;
cd_especialidade_w			bigint;
cd_area_procedimento_w		bigint;
ie_setor_w					varchar(10);


BEGIN
SELECT * FROM Obter_Proc_Tab_Interno(nr_seq_proc_interno_p, null, nr_atendimento_p, 0, cd_procedimento_w, ie_origem_proced_w) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
nr_seq_exame_w := obter_nr_seq_exame(nr_seq_proc_interno_p, nr_atendimento_p, nr_seq_rotina_p);
	
select	max(cd_grupo_proc),
	max(cd_especialidade),
	max(cd_area_procedimento)
into STRICT	cd_grupo_proc_w,
	cd_especialidade_w,
	cd_area_procedimento_w
from	estrutura_procedimento_v
where	cd_procedimento		= cd_procedimento_w
and	ie_origem_proced	= ie_origem_proced_w;

select	coalesce(max(ie_exige_setor),'N')
into STRICT	ie_setor_w
from	rep_regra_setor_proc
where	coalesce(cd_area_procedimento, cd_area_procedimento_w)	= cd_area_procedimento_w
and	coalesce(cd_especialidade, cd_especialidade_w)		= cd_especialidade_w
and	coalesce(cd_grupo_proc, cd_grupo_proc_w)			= cd_grupo_proc_w
and	coalesce(nr_seq_exame, coalesce(nr_seq_exame_w,0))		= coalesce(nr_seq_exame_w,0)
and	coalesce(cd_procedimento, cd_procedimento_w)			= cd_procedimento_w
and	coalesce(nr_seq_proc_interno, coalesce(nr_seq_proc_interno_p,0))	= coalesce(nr_seq_proc_interno_p,0);

return	ie_setor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_se_quest_setor_proc ( nr_seq_proc_interno_p bigint, nr_atendimento_p bigint, nr_seq_rotina_p bigint ) FROM PUBLIC;
