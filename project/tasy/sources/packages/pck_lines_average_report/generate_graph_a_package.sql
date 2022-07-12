-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

-- Grafico A (No. Of Line Insertions)
CREATE OR REPLACE FUNCTION pck_lines_average_report.generate_graph_a (dt_ini_p timestamp, dt_fim_p timestamp, cd_unidade_p text) RETURNS boolean AS $body$
DECLARE

  --
  c1 CURSOR FOR
    SELECT
      d.ie_classif_disp_niss as label,
      count(*) as valor
    from 
      atend_paciente_unidade apu, 
      atend_pac_dispositivo apd, 
      dispositivo d, 
      setor_atendimento sa
    where 
      apu.nr_atendimento = apd.nr_atendimento
      and apd.nr_seq_dispositivo = d.nr_sequencia
      and apu.cd_setor_atendimento = sa.cd_setor_atendimento
      and d.ie_classif_disp_niss not in ('Resp', 'SVD', 'VMI')
      and apd.dt_instalacao between dt_ini_p and dt_fim_p
      and apd.dt_instalacao between apu.dt_entrada_unidade and 
      pkg_atend_pac_unid.get_max_exit_unit(apu.nr_atendimento, apu.dt_entrada_unidade, apu.cd_setor_atendimento) 
      and sa.cd_setor_atendimento in (SELECT sa2.cd_setor_atendimento cd
      from setor_atendimento sa2, usuario_setor us
      where sa2.cd_setor_atendimento = us.cd_setor_atendimento
      and sa2.ie_situacao = 'A'
      and sa2.cd_classif_setor not in ('6', '7', '10')
      and lower(us.nm_usuario_param) = lower(wheb_usuario_pck.get_nm_usuario))
      and ((coalesce(cd_unidade_p::text, '') = '') or (obter_se_contido(sa.cd_setor_atendimento, cd_unidade_p) = 'S'))
    group by 
      sa.ds_setor_atendimento, d.ie_classif_disp_niss 
    order by label;

  r1 c1%rowtype;

BEGIN
  --Limpa tabelas
  delete FROM w_lines_avg_graph_a;

  --Abre cursor principal
  open c1;
  loop
      fetch c1 into r1;
      EXIT WHEN NOT FOUND; /* apply on c1 */

      insert into w_lines_avg_graph_a(ds_label,nr_valor)
      values (r1.label, r1.valor);

  end loop;
  close c1;

  --
  commit;
  return true;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pck_lines_average_report.generate_graph_a (dt_ini_p timestamp, dt_fim_p timestamp, cd_unidade_p text) FROM PUBLIC;