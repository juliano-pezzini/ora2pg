-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_proc_glic ( nr_seq_procedimento_p bigint, nr_seq_protocolo_p bigint, nm_usuario_p text, nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_comitar_p text default 'S', nr_seq_proc_interno_p bigint default null) AS $body$
DECLARE


nr_sequencia_w          cpoe_proc_glic.nr_sequencia%type;
qt_glic_inic_w            prescr_proc_glic.qt_glic_inic%type;
qt_glic_fim_w             prescr_proc_glic.qt_glic_fim%type;
qt_ui_insulina_w          prescr_proc_glic.qt_ui_insulina%type;
qt_glicose_w              prescr_proc_glic.qt_glicose%type;
ds_sugestao_w             prescr_proc_glic.ds_sugestao%type;
qt_minutos_medicao_w      prescr_proc_glic.qt_minutos_medicao%type;
qt_ui_insulina_int_w      prescr_proc_glic.qt_ui_insulina_int%type;

/* obter niveis protocolo */

c01 CURSOR FOR
SELECT  qt_glic_inic,
  qt_glic_fim,
  qt_ui_insulina,
  qt_ui_insulina_int,
  qt_glicose,
  ds_sugestao,
  qt_minutos_medicao
from  pep_prot_glic_nivel
where  nr_seq_protocolo = nr_seq_protocolo_p
and	coalesce((select max(IE_TIPO)
          from PEP_PROTOCOLO_GLICEMIA
         where NR_SEQUENCIA = nr_seq_protocolo_p),'C') = (select CASE WHEN max(ie_ctrl_glic)='CIG' THEN 'I'  ELSE 'C' END
                                                            from	proc_interno
                                                           where nr_sequencia = nr_seq_proc_interno_p)
order by
  nr_sequencia;


BEGIN

open C01;
loop
fetch C01 into
      qt_glic_inic_w,
      qt_glic_fim_w,
      qt_ui_insulina_w,
      qt_ui_insulina_int_w,
      qt_glicose_w,
      ds_sugestao_w,
      qt_minutos_medicao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
  begin

  select  nextval('cpoe_proc_glic_seq')
  into STRICT  nr_sequencia_w
;

  insert into cpoe_proc_glic(
          nr_sequencia,
          nr_seq_procedimento,
          nr_seq_protocolo,
          qt_glic_inic,
          qt_glic_fim,
          qt_ui_insulina,
          qt_glicose,
          ds_sugestao,
          qt_minutos_medicao,
          qt_ui_insulina_int,
          nr_seq_proc_edit,
          nr_atendimento,
          nm_usuario,
          nm_usuario_nrec,
          dt_atualizacao,
          dt_atualizacao_nrec,
          cd_pessoa_fisica)
        values (
          nr_sequencia_w,
          nr_seq_procedimento_p,
          nr_seq_protocolo_p,
          qt_glic_inic_w,
          qt_glic_fim_w,
          qt_ui_insulina_w,
          qt_glicose_w,
          ds_sugestao_w,
          qt_minutos_medicao_w,
          qt_ui_insulina_int_w,
          nr_seq_procedimento_p,
          nr_atendimento_p,
          nm_usuario_p,
          nm_usuario_p,
          clock_timestamp(),
          clock_timestamp(),
          cd_pessoa_fisica_p);

  end;
end loop;
close C01;


if (coalesce(ie_comitar_p,'S') =  'S') then
  commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_proc_glic ( nr_seq_procedimento_p bigint, nr_seq_protocolo_p bigint, nm_usuario_p text, nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_comitar_p text default 'S', nr_seq_proc_interno_p bigint default null) FROM PUBLIC;

