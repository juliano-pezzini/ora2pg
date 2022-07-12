-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_presc_observacao ( cd_pessoa_fisica_p text, dt_atualizacao_p timestamp, start_time_p timestamp, end_time_p timestamp ) RETURNS varchar AS $body$
DECLARE

    ds_others_w varchar(3900);

BEGIN
   select  rtrim(XMLAGG(XMLELEMENT(name E, notes||chr(10))).EXTRACT['//text()'].getclobval(), ',')
   into STRICT ds_others_w
from (SELECT distinct '['||obter_expressao_idioma(297315)||'] '||substr(c.DS_OBSERVACAO,1,100) ||chr(10) notes
from cpoe_material c ,MATERIAL_ORDER_TYPE mo ,CPOE_TIPO_PEDIDO ctp,Prescr_medica p, prescr_material pm,prescr_mat_hor ph
where    ctp.NR_SEQUENCIA =mo.NR_SEQ_ORDER_TYPE and  c.cd_material=mo.cd_material and NR_SEQ_SUB_GRP='PR'
  and pm.nr_sequencia = ph.nr_seq_material     and pm.nr_prescricao = ph.nr_prescricao
and p.nr_prescricao=pm.nr_prescricao and  c.CD_PESSOA_FISICA = cd_pessoa_fisica_p
and (c.DT_LIBERACAO IS NOT NULL AND c.DT_LIBERACAO::text <> '')     and coalesce(c.DT_SUSPENSAO::text, '') = ''
and (c.ds_observacao IS NOT NULL AND c.ds_observacao::text <> '')  and c.nr_sequencia =pm.NR_SEQ_MAT_CPOE
 and ph.ds_horario >=  to_Char(start_time_p,'hh24:mi:ss')     and ph.ds_horario <= to_Char(end_time_p,'hh24:mi:ss')
   and to_date(p.dt_prescricao,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy')

union all

select distinct '['||obter_expressao_idioma(296397)||'] '||substr(cp.DS_OBSERVACAO,1,100) ||chr(10) notes
from  PROC_ORDER_TYPE po ,CPOE_TIPO_PEDIDO ctp,CPOE_PROCEDIMENTO cp,PRESCR_PROCEDIMENTO pp,prescr_proc_hor ph
where  cp.NR_SEQ_PROC_INTERNO=po.NR_SEQ_PROC_INTERNO  and ctp.NR_SEQUENCIA =po.NR_SEQ_ORDER_TYPE
and NR_SEQ_SUB_GRP ='PC' and cp.CD_PESSOA_FISICA = cd_pessoa_fisica_p  and (cp.ds_observacao IS NOT NULL AND cp.ds_observacao::text <> '')
and to_date(cp.DT_ATUALIZACAO,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy') and (cp.DT_LIBERACAO IS NOT NULL AND cp.DT_LIBERACAO::text <> '')
    and coalesce(cp.DT_SUSPENSAO::text, '') = '' and  pp.CD_PROCEDIMENTO = ph.CD_PROCEDIMENTO and pp.nr_prescricao = ph.nr_prescricao
and cp.nr_sequencia=pp.NR_SEQ_PROC_CPOE and ph.ds_horario >= to_Char(start_time_p,'hh24:mi:ss')and ph.ds_horario <= to_Char(end_time_p,'hh24:mi:ss')

union all

select distinct '['||obter_expressao_idioma(1009882)||'] '||substr(c.DS_OBSERVACAO,1,100) ||chr(10) notes
from cpoe_material c ,MATERIAL_ORDER_TYPE mo ,CPOE_TIPO_PEDIDO ctp,Prescr_medica p, prescr_material pm,prescr_mat_hor ph
where    ctp.NR_SEQUENCIA =mo.NR_SEQ_ORDER_TYPE and  c.cd_material=mo.cd_material and NR_SEQ_SUB_GRP='I' and p.nr_prescricao=pm.nr_prescricao
and  c.CD_PESSOA_FISICA = cd_pessoa_fisica_p and (c.ds_observacao IS NOT NULL AND c.ds_observacao::text <> '') and c.nr_sequencia =pm.NR_SEQ_MAT_CPOE
   and to_date(p.dt_prescricao,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy')   and (c.DT_LIBERACAO IS NOT NULL AND c.DT_LIBERACAO::text <> '')
    and coalesce(c.DT_SUSPENSAO::text, '') = '' and  pm.nr_sequencia = ph. nr_seq_material and pm.nr_prescricao = ph.nr_prescricao
    and ph.ds_horario >=  to_Char(start_time_p,'hh24:mi:ss')  and ph.ds_horario <= to_Char(end_time_p,'hh24:mi:ss')


union all

select '['||obter_expressao_idioma(1013592)||'] '||substr(coalesce(c.DS_OBSERVACAO,c.DS_RECOMENDACAO),1,100) ||chr(10) notes
from CPOE_RECOMENDACAO c,CLASSIFICACAO_RECOMENDACAO cr,TIPO_RECOMENDACAO tr ,prescr_recomendacao pr,prescr_rec_hor ph
where c.CD_PESSOA_FISICA = cd_pessoa_fisica_p and ((c.ds_observacao IS NOT NULL AND c.ds_observacao::text <> '') or (c.DS_RECOMENDACAO IS NOT NULL AND c.DS_RECOMENDACAO::text <> '')) and (c.DT_LIBERACAO IS NOT NULL AND c.DT_LIBERACAO::text <> '')
    and coalesce(c.DT_SUSPENSAO::text, '') = '' and to_date(c.DT_ATUALIZACAO,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy')
    and  cr.IE_FORMA_SERVICO is  null and tr.CD_TIPO_RECOMENDACAO=c.CD_RECOMENDACAO and tr.NR_SEQ_CLASSIF=cr.nr_sequencia
    and c.nr_sequencia=pr.NR_SEQ_REC_CPOE and ph.NR_PRESCRICAO=pr.NR_PRESCRICAO
and ph.ds_horario >=  to_Char(start_time_p,'hh24:mi:ss') and ph.ds_horario <= to_Char(end_time_p,'hh24:mi:ss')

union all

select distinct '['||obter_expressao_idioma(756974)||'] '||substr(coalesce(c.DS_OBSERVACAO,c.DS_RECOMENDACAO),1,100) ||chr(10) notes
from CPOE_RECOMENDACAO c,CLASSIFICACAO_RECOMENDACAO cr,TIPO_RECOMENDACAO tr, prescr_recomendacao pr,prescr_rec_hor ph
where c.CD_PESSOA_FISICA = cd_pessoa_fisica_p and ((c.ds_observacao IS NOT NULL AND c.ds_observacao::text <> '') or (c.DS_RECOMENDACAO IS NOT NULL AND c.DS_RECOMENDACAO::text <> '')) and (c.DT_LIBERACAO IS NOT NULL AND c.DT_LIBERACAO::text <> '')
    and coalesce(c.DT_SUSPENSAO::text, '') = '' and to_date(c.DT_ATUALIZACAO,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy')
    and  (cr.IE_FORMA_SERVICO IS NOT NULL AND cr.IE_FORMA_SERVICO::text <> '') and tr.CD_TIPO_RECOMENDACAO=c.CD_RECOMENDACAO and tr.NR_SEQ_CLASSIF=cr.nr_sequencia
    and ph.NR_PRESCRICAO=pr.NR_PRESCRICAO and c.nr_sequencia=pr.NR_SEQ_REC_CPOE
and ph.ds_horario >=  to_Char(start_time_p,'hh24:mi:ss') and ph.ds_horario <= to_Char(end_time_p,'hh24:mi:ss')

union all

select distinct '['||obter_expressao_idioma(331494)||' '||obter_expressao_idioma(761511)||'] '||substr(cp.DS_OBSERVACAO,1,100) ||chr(10) notes
from  PROC_ORDER_TYPE po ,CPOE_TIPO_PEDIDO ctp,CPOE_PROCEDIMENTO cp,PRESCR_PROCEDIMENTO pp,prescr_proc_hor ph
where  cp.NR_SEQ_PROC_INTERNO=po.NR_SEQ_PROC_INTERNO  and ctp.NR_SEQUENCIA =po.NR_SEQ_ORDER_TYPE and (cp.DT_LIBERACAO IS NOT NULL AND cp.DT_LIBERACAO::text <> '')
and coalesce(cp.DT_SUSPENSAO::text, '') = '' and NR_SEQ_SUB_GRP ='R' and cp.CD_PESSOA_FISICA = cd_pessoa_fisica_p  and (cp.ds_observacao IS NOT NULL AND cp.ds_observacao::text <> '')
and to_date(cp.DT_ATUALIZACAO,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy') and  pp.CD_PROCEDIMENTO = ph.CD_PROCEDIMENTO
and pp.nr_prescricao = ph.nr_prescricao and cp.nr_sequencia= pp.NR_SEQ_PROC_CPOE and ph.ds_horario >=  to_Char(start_time_p,'hh24:mi:ss')
    and ph.ds_horario <= to_Char(end_time_p,'hh24:mi:ss')

union all

select distinct '['||obter_expressao_idioma(703250)||' '||obter_expressao_idioma(761511)||'] '||substr(cp.DS_OBSERVACAO,1,100) ||chr(10) notes
from  PROC_ORDER_TYPE po ,CPOE_TIPO_PEDIDO ctp,CPOE_PROCEDIMENTO cp,PRESCR_PROCEDIMENTO pp,prescr_proc_hor ph
where  cp.NR_SEQ_PROC_INTERNO=po.NR_SEQ_PROC_INTERNO  and ctp.NR_SEQUENCIA =po.NR_SEQ_ORDER_TYPE
and NR_SEQ_SUB_GRP ='PH' and (cp.DT_LIBERACAO IS NOT NULL AND cp.DT_LIBERACAO::text <> '')
    and coalesce(cp.DT_SUSPENSAO::text, '') = '' and to_date(cp.DT_ATUALIZACAO,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy')
    and (cp.ds_observacao IS NOT NULL AND cp.ds_observacao::text <> '')
and cp.CD_PESSOA_FISICA = cd_pessoa_fisica_p and  pp.CD_PROCEDIMENTO = ph.CD_PROCEDIMENTO
and pp.nr_prescricao = ph.nr_prescricao and cp.nr_sequencia= pp.NR_SEQ_PROC_CPOE and ph.ds_horario >=  to_Char(start_time_p,'hh24:mi:ss')
and ph.ds_horario <= to_Char(end_time_p,'hh24:mi:ss')

union all

select distinct '['||obter_expressao_idioma(330885)||'] '||substr(cp.DS_OBSERVACAO,1,100) ||chr(10) notes
from  PROC_ORDER_TYPE po ,CPOE_TIPO_PEDIDO ctp,CPOE_PROCEDIMENTO cp,PRESCR_PROCEDIMENTO pp,prescr_proc_hor ph
where  cp.NR_SEQ_PROC_INTERNO=po.NR_SEQ_PROC_INTERNO  and ctp.NR_SEQUENCIA =po.NR_SEQ_ORDER_TYPE and (cp.DT_LIBERACAO IS NOT NULL AND cp.DT_LIBERACAO::text <> '')
    and coalesce(cp.DT_SUSPENSAO::text, '') = '' and NR_SEQ_SUB_GRP ='E' and to_date(cp.DT_ATUALIZACAO,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy')
    and (cp.ds_observacao IS NOT NULL AND cp.ds_observacao::text <> '')
and cp.CD_PESSOA_FISICA = cd_pessoa_fisica_p and  pp.CD_PROCEDIMENTO = ph.CD_PROCEDIMENTO
and pp.nr_prescricao = ph.nr_prescricao and cp.nr_sequencia= pp.NR_SEQ_PROC_CPOE and ph.ds_horario >=  to_Char(start_time_p,'hh24:mi:ss')
and ph.ds_horario <= to_Char(end_time_p,'hh24:mi:ss')

union all

select distinct '['||obter_expressao_idioma(488422)||'] '||substr(cp.DS_OBSERVACAO,1,100) ||chr(10) notes
from  PROC_ORDER_TYPE po ,CPOE_TIPO_PEDIDO ctp,CPOE_PROCEDIMENTO cp,PRESCR_PROCEDIMENTO pp,prescr_proc_hor ph
where  cp.NR_SEQ_PROC_INTERNO=po.NR_SEQ_PROC_INTERNO  and ctp.NR_SEQUENCIA =po.NR_SEQ_ORDER_TYPE and (cp.DT_LIBERACAO IS NOT NULL AND cp.DT_LIBERACAO::text <> '')
    and coalesce(cp.DT_SUSPENSAO::text, '') = '' and NR_SEQ_SUB_GRP ='RE'  and to_date(cp.DT_ATUALIZACAO,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy')
    and (cp.ds_observacao IS NOT NULL AND cp.ds_observacao::text <> '') and cp.CD_PESSOA_FISICA = cd_pessoa_fisica_p and  pp.CD_PROCEDIMENTO = ph.CD_PROCEDIMENTO
and pp.nr_prescricao = ph.nr_prescricao and cp.nr_sequencia= pp.NR_SEQ_PROC_CPOE and ph.ds_horario >=  to_Char(start_time_p,'hh24:mi:ss')
and ph.ds_horario <= to_Char(end_time_p,'hh24:mi:ss')


union all

select distinct '['||obter_expressao_idioma(1042371)||'] '||substr(ac.DS_OBSERVACAO,1,100) ||chr(10) notes FROM  agenda     ag,  agenda_consulta   ac
WHERE     ag.cd_agenda = ac.cd_agenda
    and (ac.DT_CONFIRMACAO IS NOT NULL AND ac.DT_CONFIRMACAO::text <> '') and to_date(ac.DT_ATUALIZACAO,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy')
    and (ac.ds_observacao IS NOT NULL AND ac.ds_observacao::text <> '')
and ac.CD_PESSOA_FISICA = cd_pessoa_fisica_p and to_Char(ac.DT_AGENDA,'hh24:mi:ss') >=  to_Char(start_time_p,'hh24:mi:ss')
and to_Char(ac.DT_AGENDA,'hh24:mi:ss') <= to_Char(end_time_p,'hh24:mi:ss')

union all

select distinct '['||obter_expressao_idioma(1042371)||'] '||substr(ac.DS_OBSERVACAO,1,100) ||chr(10) notes FROM  agenda     ag,  agenda_paciente   ac
WHERE     ag.cd_agenda = ac.cd_agenda
    and (ac.DT_CONFIRMACAO IS NOT NULL AND ac.DT_CONFIRMACAO::text <> '') and to_date(ac.DT_ATUALIZACAO,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy') and (ac.ds_observacao IS NOT NULL AND ac.ds_observacao::text <> '')
and ac.CD_PESSOA_FISICA = cd_pessoa_fisica_p and to_Char(ac.DT_AGENDA,'hh24:mi:ss') >=  to_Char(start_time_p,'hh24:mi:ss')
and to_Char(ac.DT_AGENDA,'hh24:mi:ss') <= to_Char(end_time_p,'hh24:mi:ss')

union all

select distinct '['||obter_expressao_idioma(561220)||'] '||substr(cp.DS_OBSERVACAO,1,100) ||chr(10) notes
from  PROC_ORDER_TYPE po ,CPOE_TIPO_PEDIDO ctp,CPOE_PROCEDIMENTO cp,PRESCR_PROCEDIMENTO pp,prescr_proc_hor ph
where  cp.NR_SEQ_PROC_INTERNO=po.NR_SEQ_PROC_INTERNO  and ctp.NR_SEQUENCIA =po.NR_SEQ_ORDER_TYPE and (cp.DT_LIBERACAO IS NOT NULL AND cp.DT_LIBERACAO::text <> '')
    and coalesce(cp.DT_SUSPENSAO::text, '') = '' and NR_SEQ_SUB_GRP ='S'and to_date(cp.DT_ATUALIZACAO,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy')
    and (cp.ds_observacao IS NOT NULL AND cp.ds_observacao::text <> '') and cp.CD_PESSOA_FISICA = cd_pessoa_fisica_p and  pp.CD_PROCEDIMENTO = ph.CD_PROCEDIMENTO
and pp.nr_prescricao = ph.nr_prescricao and cp.nr_sequencia= pp.NR_SEQ_PROC_CPOE and ph.ds_horario >=  to_Char(start_time_p,'hh24:mi:ss')
and ph.ds_horario <= to_Char(end_time_p,'hh24:mi:ss')

union all

select distinct '[RI] '||substr(CASE WHEN coalesce(cp.DS_OBSERVACAO::text, '') = '' THEN null  ELSE cp.DS_OBSERVACAO END ,1,100) ||chr(10) notes
from  PROC_INTERNO pi ,CPOE_PROCEDIMENTO cp, PRESCR_PROCEDIMENTO pp,prescr_proc_hor ph
where pi.NR_SEQUENCIA=cp.NR_SEQ_PROC_INTERNO and (cp.DT_LIBERACAO IS NOT NULL AND cp.DT_LIBERACAO::text <> '')     and coalesce(cp.DT_SUSPENSAO::text, '') = ''
 and pi.IE_TIPO ='O'and to_date(cp.DT_ATUALIZACAO,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy') and (cp.ds_observacao IS NOT NULL AND cp.ds_observacao::text <> '')
and cp.CD_PESSOA_FISICA = cd_pessoa_fisica_p  and  pp.CD_PROCEDIMENTO = ph.CD_PROCEDIMENTO and pp.nr_prescricao = ph.nr_prescricao
 and coalesce(pp.nr_seq_exame::text, '') = ''
and cp.nr_sequencia= pp.NR_SEQ_PROC_CPOE and ph.ds_horario >=  to_Char(start_time_p,'hh24:mi:ss') and ph.ds_horario <= to_Char(end_time_p,'hh24:mi:ss')

union all

select distinct '['||obter_expressao_idioma(1013592)||'] '||substr(y.DS_OBSERVACAO,1,100) ||chr(10) notes from PE_PRESCR_PROC y,PE_PRESCRICAO pe
where  pe.IE_TIPO ='O' and (pe.DT_LIBERACAO IS NOT NULL AND pe.DT_LIBERACAO::text <> '')     and coalesce(pe.DT_SUSPENSAO::text, '') = ''
and y.NR_SEQ_PRESCR=pe.nr_sequencia
and to_date(pe.DT_ATUALIZACAO,'dd-mm-yy')=to_date(dt_atualizacao_p,'dd-mm-yy') and (y.ds_observacao IS NOT NULL AND y.ds_observacao::text <> '')
and pe.CD_PESSOA_FISICA = cd_pessoa_fisica_p ) alias155;
    RETURN ds_others_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_presc_observacao ( cd_pessoa_fisica_p text, dt_atualizacao_p timestamp, start_time_p timestamp, end_time_p timestamp ) FROM PUBLIC;

