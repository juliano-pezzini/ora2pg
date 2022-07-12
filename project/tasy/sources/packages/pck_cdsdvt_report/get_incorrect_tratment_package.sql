-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


   -----------------
CREATE OR REPLACE FUNCTION pck_cdsdvt_report.get_incorrect_tratment (start_date_p timestamp, end_date_p timestamp, cd_setor_p text, ds_age_p text, nr_week_p bigint) RETURNS bigint AS $body$
DECLARE


      nr_incorrect_tratment_w bigint;

      c1 CURSOR FOR
        SELECT a.nr_atendimento,
              count(b.qt_resultado) nr_incorrect_tratment
          from gqa_protocolo_pac       a,
              gqa_protocolo_etapa_pac b,
              atendimento_paciente    c,
              atend_paciente_unidade d,
              setor_atendimento s,
              usuario_setor u
        where a.nr_sequencia = b.nr_seq_prot_pac
          and d.cd_setor_atendimento = s.cd_setor_atendimento
          and s.cd_setor_atendimento = u.cd_setor_atendimento
          and c.nr_atendimento = a.nr_atendimento
          and c.nr_atendimento = d.nr_atendimento
          and d.nr_seq_interno = Obter_Atepacu_paciente(a.nr_atendimento, 'A')
          and b.nr_seq_etapa = pkg_report_data.get_stage(16,b.nr_seq_etapa)--in (3811, 3812, 3813, 3814, 3815, 3816, 3817)
          and b.qt_resultado = 0
          and b.dt_atualizacao between start_date_p and end_date_p
          and to_char(b.dt_atualizacao, 'WW') = nr_week_p
          and ((coalesce(cd_setor_p::text, '') = '') or (obter_se_contido(d.cd_setor_atendimento, cd_setor_p) = 'S'))
          and s.ie_situacao = 'A'
          and s.cd_classif_setor not in ('6', '7', '10')
          and u.nm_usuario_param = wheb_usuario_pck.get_nm_usuario
          and (obter_idade_pf(c.cd_pessoa_fisica, clock_timestamp(), 'A') >= 18 or  ds_age_p = 'X')
        group by a.nr_atendimento;

      r1 c1%rowtype;


BEGIN
       nr_incorrect_tratment_w := 0;

       --Abre cursor principal
      open c1;
      loop
         fetch c1
            into r1;
         EXIT WHEN NOT FOUND; /* apply on c1 */

         nr_incorrect_tratment_w := nr_incorrect_tratment_w + r1.nr_incorrect_tratment;

      end loop;
      close c1;

      --
      return nr_incorrect_tratment_w;

   END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pck_cdsdvt_report.get_incorrect_tratment (start_date_p timestamp, end_date_p timestamp, cd_setor_p text, ds_age_p text, nr_week_p bigint) FROM PUBLIC;
