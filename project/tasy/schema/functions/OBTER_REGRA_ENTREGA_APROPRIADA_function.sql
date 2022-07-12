-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_entrega_apropriada (nr_prescricao_p bigint, nr_seq_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE


nr_regra_w REGRA_ENTREGA.NR_SEQUENCIA%TYPE;
cd_estabelecimento_w REGRA_ENTREGA.CD_ESTABELECIMENTO%TYPE;
nr_seq_proc_interno_w REGRA_ENTREGA.NR_SEQ_PROC_INTERNO%TYPE;
cd_tipo_procedimento_w REGRA_ENTREGA.CD_TIPO_PROCEDIMENTO%TYPE;
cd_procedimento_w REGRA_ENTREGA.CD_PROCEDIMENTO%TYPE;
ie_origem_proced_w REGRA_ENTREGA.IE_ORIGEM_PROCED%TYPE;
cd_setor_atendimento_w REGRA_ENTREGA.CD_SETOR_ATENDIMENTO%TYPE;
nr_constante_w bigint;


BEGIN

nr_constante_w := -999;

select coalesce(atend_pac.cd_estabelecimento,nr_constante_w),
       coalesce(prescr_proc.cd_setor_atendimento,nr_constante_w),
	   coalesce(prescr_proc.cd_procedimento,nr_constante_w),
	   coalesce(prescr_proc.ie_origem_proced,nr_constante_w),
	   coalesce(proc.cd_tipo_procedimento,nr_constante_w),
	   coalesce(prescr_proc.nr_seq_proc_interno,nr_constante_w)
into STRICT cd_estabelecimento_w,
     cd_setor_atendimento_w,
	 cd_procedimento_w,
	 ie_origem_proced_w,
	 cd_tipo_procedimento_w,
	 nr_seq_proc_interno_w
from prescr_procedimento prescr_proc
	 join prescr_medica prescr_med on (prescr_proc.nr_prescricao = prescr_med.nr_prescricao)
	 join atendimento_paciente atend_pac on (prescr_med.nr_atendimento = atend_pac.nr_atendimento)
	 left join procedimento proc ON (prescr_proc.cd_procedimento = proc.cd_procedimento and prescr_proc.ie_origem_proced = proc.ie_origem_proced)
where prescr_proc.nr_prescricao = nr_prescricao_p
and   prescr_proc.nr_sequencia = nr_seq_prescricao_p;

select nr_sequencia
into STRICT nr_regra_w
from (	SELECT nr_sequencia
		from regra_entrega
		where coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
		and   coalesce(cd_setor_atendimento,cd_setor_atendimento_w) = cd_setor_atendimento_w
		and   coalesce(cd_tipo_procedimento,cd_tipo_procedimento_w) = cd_tipo_procedimento_w
		and   coalesce(nr_seq_proc_interno,nr_seq_proc_interno_w) = nr_seq_proc_interno_w
		and (coalesce(cd_procedimento,cd_procedimento_w) = cd_procedimento_w
			  and coalesce(ie_origem_proced,ie_origem_proced_w) = ie_origem_proced_w)
		and ie_situacao = 'A'
		and clock_timestamp() between dt_vigencia_inicial and coalesce(dt_vigencia_final,clock_timestamp())
		and (obter_se_possui_estagio(nr_sequencia)) = 'S'
		order by cd_estabelecimento,
				 cd_setor_atendimento,
				 cd_tipo_procedimento,
				 cd_procedimento,
				 ie_origem_proced,
				 nr_seq_proc_interno) alias12 LIMIT 1;

return nr_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_entrega_apropriada (nr_prescricao_p bigint, nr_seq_prescricao_p bigint) FROM PUBLIC;
