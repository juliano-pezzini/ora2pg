-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE add_volume_pos_adep (seq_cpoe_p bigint, volume_p bigint, nm_usuario_p text, nr_prescricao_p bigint, cd_profissional_p text) AS $body$
DECLARE


  nr_seq_ganho_perda_w   bigint;
  nr_sequencia_w         bigint;
  nr_seq_proc_interno_w  bigint;
  ds_proc_w              varchar(255);
  nr_seq_exame_lab_w     bigint;
  nr_seq_tipo_w          bigint;
  nr_atendimento_w       bigint;
  cd_setor_atendimento_w bigint;
  nr_sequencia_next_w    bigint;
  qt_count_w             bigint;


BEGIN

  select count(*)
    into STRICT qt_count_w
    from (SELECT a.nr_sequencia,
                 a.nr_seq_proc_interno,
                 obter_desc_proc_interno(a.nr_seq_proc_interno) ds_proc,
                 b.nr_seq_exame_lab,
                 d.nr_seq_tipo,
                 a.nr_atendimento,
                 a.cd_setor_atendimento
            from cpoe_procedimento       a,
                 proc_interno            b,
                 prescr_proc_per_gan_reg c,
                 prescr_proc_perda_ganho d
           where 1 = 1
             and b.nr_seq_exame_lab = c.nr_seq_exame
             and c.nr_seq_proc_perda_ganho = d.nr_sequencia
             and a.nr_sequencia = seq_cpoe_p
             and a.nr_seq_proc_interno = b.nr_sequencia
           order by a.dt_atualizacao desc) alias2;

  select nextval('atendimento_perda_ganho_seq')
    into STRICT nr_sequencia_next_w
;

  if (qt_count_w > 0 and (volume_p IS NOT NULL AND volume_p::text <> '') and (cd_profissional_p IS NOT NULL AND cd_profissional_p::text <> ''))
  then

    select a.nr_sequencia,
           a.nr_seq_proc_interno,
           obter_desc_proc_interno(a.nr_seq_proc_interno) ds_proc,
           b.nr_seq_exame_lab,
           d.nr_seq_tipo,
           a.nr_atendimento,
           a.cd_setor_atendimento
      into STRICT nr_sequencia_w,
           nr_seq_proc_interno_w,
           ds_proc_w,
           nr_seq_exame_lab_w,
           nr_seq_tipo_w,
           nr_atendimento_w,
           cd_setor_atendimento_w
      from cpoe_procedimento       a,
           proc_interno            b,
           prescr_proc_per_gan_reg c,
           prescr_proc_perda_ganho d
     where 1 = 1
       and b.nr_seq_exame_lab = c.nr_seq_exame
       and c.nr_seq_proc_perda_ganho = d.nr_sequencia
       and a.nr_sequencia = seq_cpoe_p
       and a.nr_seq_proc_interno = b.nr_sequencia
     order by a.dt_atualizacao desc;

    insert into atendimento_perda_ganho(nr_sequencia,
       dt_medida,
       nr_seq_tipo,
       qt_volume,
       nr_atendimento,
       cd_setor_atendimento,
       cd_turno,
       dt_atualizacao,
       nm_usuario,
       dt_liberacao,
       cd_profissional)
    values (nr_sequencia_next_w,
       clock_timestamp(),
       nr_seq_tipo_w,
       volume_p,
       nr_atendimento_w,
       cd_setor_atendimento_w,
       null,
       clock_timestamp(),
       nm_usuario_p,
       clock_timestamp(),
       cd_profissional_p);

    if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '')
    then
      update prescr_proc_material
         set qt_volume_enf = volume_p
       where nr_prescricao = nr_prescricao_p;
    end if;
  end if;

  commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE add_volume_pos_adep (seq_cpoe_p bigint, volume_p bigint, nm_usuario_p text, nr_prescricao_p bigint, cd_profissional_p text) FROM PUBLIC;

