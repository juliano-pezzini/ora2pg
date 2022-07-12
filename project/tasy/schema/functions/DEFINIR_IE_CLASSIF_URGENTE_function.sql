-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION definir_ie_classif_urgente (dt_horario_p timestamp, cd_local_estoque_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, dt_inicio_prescr_p timestamp, ie_classif_nao_padrao_p text, ie_padronizado_p text, dt_limite_especial_p timestamp, dt_limite_agora_p timestamp, ie_agora_impressao_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_turno_hor_ag_w  regra_turno_disp.nr_sequencia%type;
dt_limite_agora_w      timestamp;
hr_turno_agora_w       varchar(15);
hr_final_turno_agora_w varchar(15);
qt_min_antes_atend_w   regra_tempo_disp.qt_min_antes_atend%type;
ie_define_agora_w      regra_tempo_disp.ie_define_agora%type;
ie_classif_urgente_w   varchar(1);


BEGIN

  dt_limite_agora_w := dt_limite_agora_p;

  if (ie_agora_impressao_p = 'S') then

    nr_seq_turno_hor_ag_w  := Obter_turno_horario_prescr(cd_estabelecimento_p,cd_setor_atendimento_p,to_char(dt_horario_p,'hh24:mi'),cd_local_estoque_p);

    select max(to_char(b.hr_inicial,'hh24:mi')),
           max(to_char(b.hr_final,'hh24:mi'))
      into STRICT hr_turno_agora_w,
           hr_final_turno_agora_w
      from regra_turno_disp_param b,
           regra_turno_disp a
     where a.nr_sequencia        = b.nr_seq_turno
       and a.cd_estabelecimento  = cd_estabelecimento_p
       and a.nr_sequencia        = nr_seq_turno_hor_ag_w
       and (coalesce(b.cd_setor_atendimento,coalesce(cd_setor_atendimento_p,0))  = coalesce(cd_setor_atendimento_p,0));

    select coalesce(max(qt_min_antes_atend), 0),
           coalesce(max(ie_define_agora), 'N')
      into STRICT qt_min_antes_atend_w,
           ie_define_agora_w
      from regra_tempo_disp
     where cd_estabelecimento  = cd_estabelecimento_p
       and (coalesce(cd_setor_atendimento,coalesce(cd_setor_atendimento_p,0)) = coalesce(cd_setor_atendimento_p,0))
       and nr_seq_turno        = nr_seq_turno_hor_ag_w
       and ie_situacao         = 'A';

    if (hr_turno_agora_w > hr_final_turno_agora_w) then
      if (ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_horario_p) > ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_inicio_prescr_p)) then
        dt_limite_agora_w := pkg_date_utils.get_time(dt_horario_p - 1, hr_turno_agora_w, 0) - (qt_min_antes_atend_w/1440);
      else
        dt_limite_agora_w := pkg_date_utils.get_time(dt_horario_p, hr_turno_agora_w, 0) - (qt_min_antes_atend_w/1440);
      end if;
    else
      dt_limite_agora_w := pkg_date_utils.get_time(dt_horario_p, hr_turno_agora_w, 0) - (qt_min_antes_atend_w/1440);
    end if;
  end if;

  if (coalesce(ie_classif_nao_padrao_p::text, '') = '') or (ie_padronizado_p = 'S') then
			begin
			ie_classif_urgente_w	:= 'N';
			if (dt_horario_p <= dt_limite_agora_w) then
				ie_classif_urgente_w	:= 'A';
			elsif	((dt_limite_agora_w <= clock_timestamp()) and (ie_agora_impressao_p = 'S') and (ie_define_agora_w = 'N')) then
				ie_classif_urgente_w	:= 'A';
			elsif (ie_agora_impressao_p = 'S' and ie_define_agora_w = 'S') and
				(dt_horario_p <= (clock_timestamp() + (qt_min_antes_atend_w /1440))) then
				ie_classif_urgente_w	:= 'A';
			elsif (dt_horario_p <= dt_limite_especial_p) then
				ie_classif_urgente_w	:= 'E';
			end if;
			end;
		else
			return ie_classif_nao_padrao_p;
		end if;

  return ie_classif_urgente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION definir_ie_classif_urgente (dt_horario_p timestamp, cd_local_estoque_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, dt_inicio_prescr_p timestamp, ie_classif_nao_padrao_p text, ie_padronizado_p text, dt_limite_especial_p timestamp, dt_limite_agora_p timestamp, ie_agora_impressao_p text) FROM PUBLIC;
