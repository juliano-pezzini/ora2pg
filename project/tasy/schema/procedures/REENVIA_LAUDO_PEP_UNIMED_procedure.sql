-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reenvia_laudo_pep_unimed (nr_prescricao_p bigint, nr_seq_prescr_p bigint, tipo_laudo_p text, nm_usuario_p text) AS $body$
DECLARE


acao_w                 varchar(11);
total_err_w            smallint;
total_w                bigint;
total_canc_w           bigint;
nr_seq_exame_w         prescr_procedimento.nr_seq_exame%type;
cd_procedimento_w      prescr_procedimento.cd_procedimento%type;
ie_origem_proced_w     prescr_procedimento.ie_origem_proced%type;
nr_seq_proc_interno_w  prescr_procedimento.nr_seq_proc_interno%type;
ie_suspenso_w          prescr_procedimento.ie_suspenso%type;
ie_status_atend_w      prescr_procedimento.ie_status_atend%type;

BEGIN
  if (tipo_laudo_p = 'L') then
      begin
          select ie_status_atend
          into STRICT ie_status_atend_w
          from prescr_procedimento
          where nr_prescricao = nr_prescricao_p
              and nr_sequencia = nr_seq_prescr_p
              and (nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '');

          if (ie_status_atend_w >= 35) then
              acao_w := 'Registro';
              total_w := 1;
          else
              acao_w := 'Exclusao';
              total_w := 1;
          end if;
      exception
          when others then
              total_w := 0;
      end;
  else
   select sum(total)
     into STRICT total_w
     from (SELECT count(1) total
             from prescr_procedimento a
            inner join procedimento_paciente pp on pp.nr_prescricao = a.nr_prescricao
            inner join atend_categoria_convenio acc on acc.nr_atendimento = pp.nr_atendimento
            inner join prescr_medica d on d.nr_prescricao = a.nr_prescricao
            inner join procedimento p on p.cd_procedimento = a.cd_procedimento and p.ie_origem_proced = a.ie_origem_proced
            where a.nr_prescricao = nr_prescricao_p
              and a.nr_sequencia = nr_seq_prescr_p) alias2;

   if (total_w > 0) then
     acao_w := 'Registro';

     select count(1)
        into STRICT total_err_w
        from prescr_proced_info_ext
        where cd_mensagem_ext = 'PEPUNIMEDW'
        and nr_prescricao = nr_prescricao_p
        and nr_seq_prescr = nr_seq_prescr_p;

     if (total_err_w > 0) then
      delete from prescr_proced_info_ext
              where cd_mensagem_ext = 'PEPUNIMEDW'
              and nr_prescricao = nr_prescricao_p
              and nr_seq_prescr = nr_seq_prescr_p;
     end if;
   end if;
  end if;

  if (total_w > 0) then
    CALL integrar_unimed_rs_ws(766, nr_prescricao_p, nr_seq_prescr_p, nm_usuario_p, acao_w);
  end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reenvia_laudo_pep_unimed (nr_prescricao_p bigint, nr_seq_prescr_p bigint, tipo_laudo_p text, nm_usuario_p text) FROM PUBLIC;
