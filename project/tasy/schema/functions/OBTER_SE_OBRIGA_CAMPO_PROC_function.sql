-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_obriga_campo_proc (nr_prescricao_p bigint, nr_seq_exame_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_prev_execucao_p timestamp, ds_justificativa_p text, cd_material_exame_p text, cd_setor_atendimento_p bigint, cd_intervalo_p text, ie_campo_p bigint) RETURNS varchar AS $body$
DECLARE

			
/*
Junior - OS 493496
Opção ie_campo_p 999 para verificar se apresenta tela para informar justificativa (somente se ie_campo_obriga da tabela = 6 - Justificativa)
*/
			
ie_retorno_w	varchar(1) := 'N';
/* procedimento */

cd_procedimento_w		procedimento.cd_procedimento%type;
ie_origem_proced_w		procedimento.ie_origem_proced%type;
cd_material_exame_w		varchar(20);
dt_prev_execucao_w		timestamp;
ie_proced_lado_w		varchar(15);
ie_lado_w			varchar(15);
ie_situacao_proced_w		varchar(1);
nr_seq_exame_w			bigint;
cd_especialidade_proced_w	bigint;
cd_setor_proced_w		integer;
ie_classificacao_w		varchar(1);
qt_procedimento_w		double precision;
nr_seq_proc_interno_w		bigint;
ds_dado_clinico_w		varchar(2000);
ds_resumo_clinico_w		varchar(2000);
nr_seq_grupo_exame_w		bigint;
cd_area_procedimento_w		bigint;
cd_grupo_procedimento_w		bigint;
nr_seq_subgrupo_w		bigint;
dt_prev_execucao_mi_w		timestamp;
nr_seq_prot_glic_w		bigint;
ie_setor_exec_proced_w		varchar(1);
ie_proced_agora_w		varchar(1);
cd_setor_atendimento_w		integer;
ie_consiste_medic_proc_w	varchar(1);
ie_consiste_prescr_proc_w	varchar(1);
cd_estab_prescr_w		integer;
ie_consiste_exame_dia_w		varchar(1);
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
cd_tipo_acomodacao_w		smallint;
ie_tipo_atendimento_w		smallint;
cd_setor_prescricao_w		integer;
cd_tipo_convenio_w		smallint;
cd_tipo_procedimento_w		bigint;
cd_perfil_w			bigint;


BEGIN

cd_procedimento_w := cd_procedimento_p;
ie_origem_proced_w := ie_origem_proced_p;

if ( (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') and
     ( (coalesce(cd_procedimento_p, 0) = 0) or coalesce(ie_origem_proced_p::text, '') = '' ) ) then
    select  cd_procedimento,
            ie_origem_proced
    into STRICT    cd_procedimento_w,
            ie_origem_proced_w
    from    proc_interno
    where   nr_sequencia = nr_seq_proc_interno_p;

end if;

cd_perfil_w := wheb_usuario_pck.get_cd_perfil;

select	obter_especialidade_proced(cd_procedimento_w,ie_origem_proced_w),
        a.cd_estabelecimento,
        obter_tipo_atendimento(a.nr_atendimento),
        obter_grupo_exame_lab(nr_seq_exame_p),
        c.cd_area_procedimento,
        c.cd_grupo_proc,
        coalesce(substr(sus_obter_seq_estrut_proc(sus_obter_estrut_proc(cd_procedimento_w,ie_origem_proced_w,'C','S'),'S'),1,10),0),
        a.cd_setor_atendimento,
        c.cd_tipo_procedimento,
        Obter_Tipo_Convenio(obter_convenio_atendimento(a.nr_atendimento))
into STRICT	cd_especialidade_proced_w,
        cd_estab_prescr_w,
        ie_tipo_atendimento_w,
        nr_seq_grupo_exame_w,
        cd_area_procedimento_w,
        cd_grupo_procedimento_w,
        nr_seq_subgrupo_w,
        cd_setor_prescricao_w,
        cd_tipo_procedimento_w,
        cd_tipo_convenio_w
from	Estrutura_Procedimento_v c,
	    prescr_medica a		
where	cd_procedimento_w	= c.cd_procedimento
and	    ie_origem_proced_w	= c.ie_origem_proced
and	    a.nr_prescricao		= nr_prescricao_p;
	
select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_retorno_w
from	regra_indic_clinica_obrig
where	coalesce(nr_seq_exame_lab,coalesce(nr_seq_exame_p,0))		= coalesce( nr_seq_exame_p,0)
and	    coalesce(nr_seq_grupo_lab,coalesce(nr_seq_grupo_exame_w,0))	= coalesce( nr_seq_grupo_exame_w,0)
and	    coalesce(nr_seq_exame_interno,coalesce(nr_seq_proc_interno_p,0))	= coalesce( nr_seq_proc_interno_p,0)
and	    coalesce(cd_area_procedimento,coalesce(cd_area_procedimento_w,0))	= coalesce( cd_area_procedimento_w,0)
and	    coalesce(cd_especialidade,coalesce(cd_especialidade_proced_w,0))	= coalesce( cd_especialidade_proced_w,0)
and	    coalesce(cd_grupo_proc,coalesce(cd_grupo_procedimento_w,0))	= coalesce( cd_grupo_procedimento_w,0)
and	    coalesce(cd_procedimento,coalesce(cd_procedimento_w,0))		= coalesce( cd_procedimento_w,0)
and	    coalesce(ie_origem_proced,coalesce(ie_origem_proced_w,0))		= coalesce( ie_origem_proced_w,0)
and	    coalesce(cd_intervalo,coalesce(cd_intervalo_p,0))			= coalesce( cd_intervalo_p,0)
and	    coalesce(nr_seq_subgrupo,nr_seq_subgrupo_w)			= nr_seq_subgrupo_w
and	    coalesce(cd_perfil,coalesce(cd_perfil_w,0))			= coalesce(cd_perfil_w,0)
and	    coalesce(cd_setor_prescricao,coalesce(cd_setor_prescricao_w,0))	= coalesce( cd_setor_prescricao_w,0)
and	    coalesce(cd_setor_executor,coalesce(cd_setor_atendimento_p,0))	= coalesce( cd_setor_atendimento_p,0)
and	    coalesce(cd_tipo_procedimento, coalesce(cd_tipo_procedimento_w,0)) = coalesce( cd_tipo_procedimento_w,0)
and	    coalesce(ie_tipo_convenio, coalesce(cd_tipo_convenio_w,0))	= coalesce( cd_tipo_convenio_w,0)
and	    Obter_Regra_obrig_proc(nr_sequencia, ie_tipo_atendimento_w, cd_material_exame_p ) = 'S'
and	    cd_estabelecimento					= cd_estab_prescr_w
and	    ((coalesce(hr_prev_inicial::text, '') = '') or (to_char(dt_prev_execucao_p,'hh24:mi')	>= substr(hr_prev_inicial,1,5)))
and	    ((coalesce(hr_prev_final::text, '') = '') or (to_char( dt_prev_execucao_p,'hh24:mi')	<= substr(hr_prev_final,1,5)))
and	    ((coalesce(ie_campo_obriga,'0') = to_char(ie_campo_p)) or
	     ((ie_campo_p = 999) and (ie_campo_obriga = '6') and (coalesce(ie_justif_rotina,'N') = 'S')));
return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_obriga_campo_proc (nr_prescricao_p bigint, nr_seq_exame_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_prev_execucao_p timestamp, ds_justificativa_p text, cd_material_exame_p text, cd_setor_atendimento_p bigint, cd_intervalo_p text, ie_campo_p bigint) FROM PUBLIC;

