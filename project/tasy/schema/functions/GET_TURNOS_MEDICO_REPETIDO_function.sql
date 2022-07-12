-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_turnos_medico_repetido (ie_dia_semana_p bigint, hr_inicial_p timestamp, hr_final_p timestamp, dt_inicio_vigencia_p timestamp, dt_final_vigencia_p timestamp, cd_medico_p text, nr_seq_turno_p bigint, ie_semana_p bigint, nr_seq_turno_medico_p bigint, nr_seq_turno_classif_p bigint, cd_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


dt_atual_w varchar(100);
hr_inicial_w timestamp;
hr_final_w timestamp;
hr_inicial_turno_w timestamp;
hr_final_turno_w timestamp;

ie_dia_semana_w smallint;
hr_inicial_ww timestamp;
hr_final_ww timestamp;
dt_inicio_vigencia_w timestamp;
dt_final_vigencia_w timestamp;
dt_padrao_futura_w timestamp;
cd_medico_w varchar(20);
nr_seq_turno_w bigint;
ie_semana_w smallint;
dt_inicio_vigencia_cursor_w timestamp;
dt_final_vigencia_cursor_w  timestamp;
ds_retorno_w varchar(4000);
nm_usuario_w varchar(20);
cd_estabelecimento_w smallint;
ds_texo_agenda_w varchar(255);
ds_texo_turno_w varchar(255);
ds_texo_hora_w varchar(255);
ie_valida_prof_turno_w varchar(1);

c01 CURSOR FOR
  SELECT a.nr_sequencia,
        a.ie_dia_semana,
        a.hr_inicial,
        a.hr_final,
        a.dt_inicio_vigencia,
        a.dt_final_vigencia,
        a.ie_semana,
        b.cd_agenda,
        b.cd_estabelecimento,
        b.ie_ordenacao
  from agenda_turno a,
      agenda b 
  where	a.cd_agenda = b.cd_agenda
  and b.cd_tipo_agenda = 3
  and b.cd_pessoa_fisica = cd_medico_w
  and b.cd_agenda <> cd_agenda_p
  
union all

  SELECT c.nr_sequencia,
        c.ie_dia_semana,
        c.hr_inicial,
        c.hr_final,
        c.dt_agenda dt_inicio_vigencia,
        c.dt_agenda_fim dt_final_vigencia,
        0 ie_semana,
        d.cd_agenda,
        d.cd_estabelecimento,
        d.ie_ordenacao 
  from agenda_turno_esp c,
      agenda d 
  where	c.cd_agenda = d.cd_agenda
  and d.cd_tipo_agenda = 3
  and d.cd_pessoa_fisica = cd_medico_w
  and d.cd_agenda <> cd_agenda_p;

c02 CURSOR FOR 
SELECT a.dt_dia_semana,
  a.hr_inicial,
  a.hr_final,
  a.dt_inicio_vigencia,
  a.dt_final_vigencia,
  a.cd_medico,
  a.ie_semana,
  'N' turno,
  a.nr_sequencia,
  b.cd_agenda,
  b.ds_agenda
from agenda_horario a,
    agenda b
where	a.cd_agenda = b.cd_agenda
and b.cd_tipo_agenda = 2
and (a.cd_medico = cd_medico_w or nr_sequencia(SELECT e.nr_seq_turno from agenda_medico e where e.cd_medico = cd_medico_w))
and b.cd_agenda <> cd_agenda_p

union all

select c.ie_dia_semana dt_dia_semana,
  c.hr_inicial,
  c.hr_final,
  c.dt_agenda dt_inicio_vigencia,
  c.dt_agenda_fim dt_final_vigencia,
  c.cd_medico,
  0 ie_semana,
  'E' turno,
  c.nr_sequencia,
  d.cd_agenda,
  d.ds_agenda
from agenda_horario_esp c,
    agenda d 
where	c.cd_agenda = d.cd_agenda
and d.cd_tipo_agenda = 2
and c.cd_medico = cd_medico_w
and d.cd_agenda <> cd_agenda_p;

c03 CURSOR FOR
  SELECT a.nr_sequencia,
        a.ie_dia_semana,
        a.hr_inicial,
        a.hr_final,
        a.dt_inicio_vigencia,
        a.dt_final_vigencia,
        a.ie_semana,
        b.cd_agenda,
        b.ds_agenda
  from agenda_turno a,
      agenda b,
      agenda_turno_classif c
  where	a.cd_agenda = b.cd_agenda
  and b.cd_tipo_agenda = 5
  and c.nr_seq_turno = a.nr_sequencia
  and c.cd_medico = cd_medico_w
  and b.cd_agenda <> cd_agenda_p;

function validar_data_vigencia_repetido(dt_inicio_cursor timestamp, dt_final_cursor timestamp, dt_inicio_parametro timestamp, dt_final_parametro timestamp) return text is

dt_inicio_parametro_w timestamp;
dt_final_parametro_w  timestamp;
BEGIN
-- as duas datas vazias
if (coalesce(dt_inicio_parametro::text, '') = '' and coalesce(dt_final_parametro::text, '') = '') then
  return 'S';
end if;
-- data inicial com valor e data final null
if ((trunc(dt_inicio_parametro) between dt_inicio_cursor and dt_final_cursor) and coalesce(dt_final_parametro::text, '') = '') then
  return 'S';
end if;
--data final com valor e data incial null
if ((fim_dia(dt_final_parametro) between dt_inicio_cursor and dt_final_cursor) and coalesce(dt_inicio_parametro::text, '') = '') then
  return 'S';
end if;
dt_inicio_parametro_w := coalesce(dt_inicio_parametro, clock_timestamp());
dt_final_parametro_w := coalesce(dt_final_parametro, dt_padrao_futura_w);
-- data inicial e dinal com valor
if ((trunc(dt_inicio_parametro_w) between dt_inicio_cursor and dt_final_cursor) or (fim_dia(dt_final_parametro_w) between dt_inicio_cursor and dt_final_cursor)) then
  return 'S';
end if;
-- data inicial e dinal com valor
if ((trunc(dt_inicio_cursor) between dt_inicio_parametro_w and dt_final_parametro_w) or (fim_dia(dt_final_cursor) between dt_inicio_parametro_w and dt_final_parametro_w)) then
  return 'S';
end if;

return 'N';
end;

begin

cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

select max(coalesce(ie_valida_prof_turno, 'N'))
into STRICT ie_valida_prof_turno_w
from parametro_agenda
where cd_estabelecimento = cd_estabelecimento_w;

if (ie_valida_prof_turno_w = 'N') then
  return ds_retorno_w;
end if;

if (nr_seq_turno_medico_p IS NOT NULL AND nr_seq_turno_medico_p::text <> '') then

  select a.dt_dia_semana,
    a.hr_inicial,
    a.hr_final,
    a.dt_inicio_vigencia,
    a.dt_final_vigencia,
    cd_medico_p,
    a.nr_sequencia,
    a.ie_semana
  into STRICT ie_dia_semana_w,
    hr_inicial_ww,
    hr_final_ww,
    dt_inicio_vigencia_w,
    dt_final_vigencia_w,
    cd_medico_w,
    nr_seq_turno_w,
    ie_semana_w
  from agenda_horario a
  where	nr_sequencia = nr_seq_turno_medico_p;

elsif (nr_seq_turno_classif_p IS NOT NULL AND nr_seq_turno_classif_p::text <> '') then

  select a.ie_dia_semana,
    a.hr_inicial,
    a.hr_final,
    a.dt_inicio_vigencia,
    a.dt_final_vigencia,
    cd_medico_p,
    a.nr_sequencia,
    a.ie_semana
  into STRICT ie_dia_semana_w,
    hr_inicial_ww,
    hr_final_ww,
    dt_inicio_vigencia_w,
    dt_final_vigencia_w,
    cd_medico_w,
    nr_seq_turno_w,
    ie_semana_w
  from agenda_turno a
  where	a.nr_sequencia = nr_seq_turno_classif_p;

else

  ie_dia_semana_w := ie_dia_semana_p;
  hr_inicial_ww := hr_inicial_p + (1/1440);
  hr_final_ww := hr_final_p - (1/1440);
  dt_inicio_vigencia_w := dt_inicio_vigencia_p;
  dt_final_vigencia_w := dt_final_vigencia_p;
  cd_medico_w  := cd_medico_p;
  nr_seq_turno_w := nr_seq_turno_p;
  ie_semana_w := ie_semana_p;

end if;

dt_atual_w := to_char(clock_timestamp(), 'dd/mm/yyyy') || ' ';
hr_inicial_w := to_date(dt_atual_w || to_char(hr_inicial_ww, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');
hr_final_w := to_date(dt_atual_w || to_char(hr_final_ww, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');
dt_padrao_futura_w := to_date('9999', 'yyyy');
nm_usuario_w := wheb_usuario_pck.get_nm_usuario;
ds_texo_agenda_w := obter_desc_expressao(330345);
ds_texo_turno_w  := ' ' || obter_desc_expressao(300543) || ':';
ds_texo_hora_w   := ' ' || obter_desc_expressao(343782);

for r_c01 in c01 loop

  hr_inicial_turno_w := to_date(dt_atual_w || to_char(r_c01.hr_inicial, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');
  hr_final_turno_w := to_date(dt_atual_w || to_char(r_c01.hr_final, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');
  dt_inicio_vigencia_cursor_w := trunc(coalesce(r_c01.dt_inicio_vigencia,clock_timestamp()));
  dt_final_vigencia_cursor_w := fim_dia(coalesce(r_c01.dt_final_vigencia,dt_padrao_futura_w));

  if (r_c01.nr_sequencia <> nr_seq_turno_w) and (coalesce(r_c01.ie_dia_semana::text, '') = '' or coalesce(ie_dia_semana_w::text, '') = '' or r_c01.ie_dia_semana = ie_dia_semana_w or (r_c01.ie_dia_semana = 9 and ie_dia_semana_w not in (1,7)) or (ie_dia_semana_w = 9 and r_c01.ie_dia_semana not in (1,7))) and (r_c01.ie_semana = ie_semana_w or (r_c01.ie_semana = 0 and ie_semana_w <> 0) or (ie_semana_w = 0 and r_c01.ie_semana <> 0)) and
    ((hr_final_w between hr_inicial_turno_w and hr_final_turno_w) or (hr_inicial_w between hr_inicial_turno_w and hr_final_turno_w) or (hr_inicial_turno_w between hr_inicial_w and hr_final_w) or (hr_final_turno_w between hr_inicial_w and hr_final_w)) and       --valida as quatro possibilidades de tempo
    validar_data_vigencia_repetido(dt_inicio_vigencia_cursor_w, dt_final_vigencia_cursor_w, dt_inicio_vigencia_w, dt_final_vigencia_w) = 'S' then

      ds_retorno_w := ds_retorno_w || ds_texo_agenda_w || r_c01.cd_agenda || '-' || substr(obter_nome_medico_combo_agcons(r_c01.cd_estabelecimento, r_c01.cd_agenda, 3, r_c01.ie_ordenacao),1,240)
      || ds_texo_turno_w|| r_c01.nr_sequencia || ds_texo_hora_w || pkg_date_formaters.to_varchar(hr_inicial_turno_w, 'shortTime', cd_estabelecimento_w, nm_usuario_w)
      || '-' || pkg_date_formaters.to_varchar(hr_final_turno_w, 'shortTime', cd_estabelecimento_w, nm_usuario_w) || ';';

  end if;

end loop;

for r_c02 in c02 loop

  hr_inicial_turno_w := to_date(dt_atual_w || to_char(r_c02.hr_inicial, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');
  hr_final_turno_w := to_date(dt_atual_w || to_char(r_c02.hr_final, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');
  dt_inicio_vigencia_cursor_w := trunc(coalesce(r_c02.dt_inicio_vigencia,clock_timestamp()));
  dt_final_vigencia_cursor_w := fim_dia(coalesce(r_c02.dt_final_vigencia,dt_padrao_futura_w));

  if (r_c02.nr_sequencia <> nr_seq_turno_w) and (coalesce(r_c02.dt_dia_semana::text, '') = '' or coalesce(ie_dia_semana_w::text, '') = '' or r_c02.dt_dia_semana = ie_dia_semana_w or (r_c02.dt_dia_semana = 9 and ie_dia_semana_w not in (1,7)) or (ie_dia_semana_w = 9 and r_c02.dt_dia_semana not in (1,7))) and (r_c02.ie_semana = ie_semana_w or (r_c02.ie_semana = 0 and ie_semana_w <> 0) or (ie_semana_w = 0 and r_c02.ie_semana <> 0)) and
    ((hr_final_w between hr_inicial_turno_w and hr_final_turno_w) or (hr_inicial_w between hr_inicial_turno_w and hr_final_turno_w) or (hr_inicial_turno_w between hr_inicial_w and hr_final_w) or (hr_final_turno_w between hr_inicial_w and hr_final_w)) then --valida as quatro possibilidades de tempo
    if (r_c02.turno = 'N') and
        validar_data_vigencia_repetido(dt_inicio_vigencia_cursor_w, dt_final_vigencia_cursor_w, dt_inicio_vigencia_w, dt_final_vigencia_w) = 'S' then
        
      ds_retorno_w := ds_retorno_w || ds_texo_agenda_w || r_c02.cd_agenda || '-' || r_c02.ds_agenda ||
      ds_texo_turno_w|| r_c02.nr_sequencia || ds_texo_hora_w || pkg_date_formaters.to_varchar(hr_inicial_turno_w, 'shortTime', cd_estabelecimento_w, nm_usuario_w)
      || '-' || pkg_date_formaters.to_varchar(hr_final_turno_w, 'shortTime', cd_estabelecimento_w, nm_usuario_w) || ';';

    elsif (r_c02.turno = 'E') and (dt_inicio_vigencia_cursor_w between coalesce(dt_inicio_vigencia_w, clock_timestamp()) and coalesce(dt_final_vigencia_w, dt_padrao_futura_w)) then
          
      ds_retorno_w := ds_retorno_w || ds_texo_agenda_w || r_c02.cd_agenda || '-' || r_c02.ds_agenda ||
      ds_texo_turno_w|| r_c02.nr_sequencia || ds_texo_hora_w || pkg_date_formaters.to_varchar(hr_inicial_turno_w, 'shortTime', cd_estabelecimento_w, nm_usuario_w)
      || '-' || pkg_date_formaters.to_varchar(hr_final_turno_w, 'shortTime', cd_estabelecimento_w, nm_usuario_w) || ';';

    end if;

  end if;

end loop;

for r_c03 in c03 loop

  hr_inicial_turno_w := to_date(dt_atual_w || to_char(r_c03.hr_inicial, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');
  hr_final_turno_w := to_date(dt_atual_w || to_char(r_c03.hr_final, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');
  dt_inicio_vigencia_cursor_w := trunc(coalesce(r_c03.dt_inicio_vigencia,clock_timestamp()));
  dt_final_vigencia_cursor_w := fim_dia(coalesce(r_c03.dt_final_vigencia,dt_padrao_futura_w));

  if (r_c03.nr_sequencia <> nr_seq_turno_w) and (coalesce(r_c03.ie_dia_semana::text, '') = '' or r_c03.ie_dia_semana = ie_dia_semana_w or (r_c03.ie_dia_semana = 9 and ie_dia_semana_w not in (1,7)) or (ie_dia_semana_w = 9 and r_c03.ie_dia_semana not in (1,7))) and (r_c03.ie_semana = ie_semana_w or (r_c03.ie_semana = 0 and ie_semana_w <> 0) or (ie_semana_w = 0 and r_c03.ie_semana <> 0)) and
    ((hr_final_w between hr_inicial_turno_w and hr_final_turno_w) or (hr_inicial_w between hr_inicial_turno_w and hr_final_turno_w)or (hr_inicial_turno_w between hr_inicial_w and hr_final_w) or (hr_final_turno_w between hr_inicial_w and hr_final_w)) and       --valida as quatro possibilidades de tempo
    validar_data_vigencia_repetido(dt_inicio_vigencia_cursor_w, dt_final_vigencia_cursor_w, dt_inicio_vigencia_w, dt_final_vigencia_w) = 'S' then

      ds_retorno_w := ds_retorno_w || ds_texo_agenda_w || r_c03.cd_agenda || '-' || r_c03.ds_agenda ||
      ds_texo_turno_w || r_c03.nr_sequencia || ds_texo_hora_w || pkg_date_formaters.to_varchar(hr_inicial_turno_w, 'shortTime', cd_estabelecimento_w, nm_usuario_w)
      || '-' || pkg_date_formaters.to_varchar(hr_final_turno_w, 'shortTime', cd_estabelecimento_w, nm_usuario_w) || ';';

  end if;

end loop;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_turnos_medico_repetido (ie_dia_semana_p bigint, hr_inicial_p timestamp, hr_final_p timestamp, dt_inicio_vigencia_p timestamp, dt_final_vigencia_p timestamp, cd_medico_p text, nr_seq_turno_p bigint, ie_semana_p bigint, nr_seq_turno_medico_p bigint, nr_seq_turno_classif_p bigint, cd_agenda_p bigint) FROM PUBLIC;

