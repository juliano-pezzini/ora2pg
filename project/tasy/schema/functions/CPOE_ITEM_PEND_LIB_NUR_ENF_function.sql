-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_item_pend_lib_nur_enf (nr_atendimento_p bigint, ie_tomorrow_p text, ie_momento_lote_p text, ie_return_desc_p text default 'N', nr_seq_cpoe_p bigint default null, ie_tipo_item_p text default '') RETURNS varchar AS $body$
DECLARE

ds_alerta_w     varchar(4000)  := null;
c_dieta CURSOR FOR
SELECT a.nr_sequencia,
    cpoe_obter_desc_dieta_simp(a.nr_sequencia) ds_item
from  cpoe_dieta a,
      cpoe_inf_adic b
where a.nr_sequencia = b.nr_seq_diet_cpoe
and coalesce(b.dt_ack_nurse::text, '') = ''
and coalesce(b.nm_user_ack::text, '') = ''
and (a.nr_atendimento = nr_atendimento_p or (a.nr_sequencia = nr_seq_cpoe_p and ie_tipo_item_p in ('D', 'S', 'J', 'SNE', 'NPN', 'NAN', 'NPA', 'LD')))
and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and coalesce(a.dt_lib_suspensao::text, '') = ''
and ((ie_tomorrow_p = 'A') or (ie_tomorrow_p = 'N' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio >= trunc(clock_timestamp() + interval '2 days')) or (ie_tomorrow_p = 'S' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio < trunc(clock_timestamp() + interval '2 days')));
c_material CURSOR FOR
SELECT a.nr_sequencia,
    cpoe_obter_desc_item(a.nr_sequencia, 'M') ds_item
from  cpoe_material a,
      cpoe_inf_adic b
where a.nr_sequencia = b.nr_seq_mat_cpoe
and coalesce(b.dt_ack_nurse::text, '') = ''
and coalesce(b.nm_user_ack::text, '') = ''
and (a.nr_atendimento = nr_atendimento_p or (a.nr_sequencia = nr_seq_cpoe_p and ie_tipo_item_p in ('M', 'MAT', 'SOL')))
and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and coalesce(a.dt_lib_suspensao::text, '') = ''
and ((ie_tomorrow_p = 'A') or (ie_tomorrow_p = 'N' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio >= trunc(clock_timestamp() + interval '2 days')) or (ie_tomorrow_p = 'S' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio < trunc(clock_timestamp() + interval '2 days')));
c_dialise CURSOR FOR
SELECT a.nr_sequencia,
    cpoe_obter_desc_item(a.nr_sequencia, 'DI') ds_item
from cpoe_dialise a,
    cpoe_inf_adic b
where a.nr_sequencia = b.nr_seq_dial_cpoe
and coalesce(b.dt_ack_nurse::text, '') = ''
and coalesce(b.nm_user_ack::text, '') = ''
and (a.nr_atendimento = nr_atendimento_p or (a.nr_sequencia = nr_seq_cpoe_p and ie_tipo_item_p in ('DI')))
and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and coalesce(a.dt_lib_suspensao::text, '') = ''
and ((ie_tomorrow_p = 'A') or (ie_tomorrow_p = 'N' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio >= trunc(clock_timestamp() + interval '2 days')) or (ie_tomorrow_p = 'S' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio < trunc(clock_timestamp() + interval '2 days')));
c_gasoterapia CURSOR FOR
SELECT a.nr_sequencia,
    cpoe_obter_desc_item(a.nr_sequencia, 'O') ds_item
from cpoe_gasoterapia a,
    cpoe_inf_adic b
where a.nr_sequencia = b.nr_seq_gaso_cpoe
and coalesce(b.dt_ack_nurse::text, '') = ''
and coalesce(b.nm_user_ack::text, '') = ''
and (a.nr_atendimento = nr_atendimento_p or (a.nr_sequencia = nr_seq_cpoe_p and ie_tipo_item_p in ('O')))
and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and coalesce(a.dt_lib_suspensao::text, '') = ''
and ((ie_tomorrow_p = 'A') or (ie_tomorrow_p = 'N' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio >= trunc(clock_timestamp() + interval '2 days')) or (ie_tomorrow_p = 'S' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio < trunc(clock_timestamp() + interval '2 days')));
c_hemoterapia CURSOR FOR
SELECT a.nr_sequencia,
    cpoe_obter_desc_item(a.nr_sequencia, 'H') ds_item
from cpoe_hemoterapia a,
    cpoe_inf_adic b
where a.nr_sequencia = b.nr_seq_hemo_cpoe
and coalesce(b.dt_ack_nurse::text, '') = ''
and coalesce(b.nm_user_ack::text, '') = ''
and (a.nr_atendimento = nr_atendimento_p or (a.nr_sequencia = nr_seq_cpoe_p and ie_tipo_item_p in ('HM')))
and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and coalesce(a.dt_lib_suspensao::text, '') = ''
and ((ie_tomorrow_p = 'A') or (ie_tomorrow_p = 'N' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio >= trunc(clock_timestamp() + interval '2 days')) or (ie_tomorrow_p = 'S' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio < trunc(clock_timestamp() + interval '2 days')));
c_procedimento CURSOR FOR
SELECT a.nr_sequencia,
    cpoe_obter_desc_item(a.nr_sequencia, 'P') ds_item
from cpoe_procedimento a,
    cpoe_inf_adic b
where a.nr_sequencia = b.nr_seq_exam_cpoe
and coalesce(b.dt_ack_nurse::text, '') = ''
and coalesce(b.nm_user_ack::text, '') = ''
and (a.nr_atendimento = nr_atendimento_p or (a.nr_sequencia = nr_seq_cpoe_p and ie_tipo_item_p in ('P', 'C', 'G', 'I', 'L')))
and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and coalesce(a.dt_lib_suspensao::text, '') = ''
and ((ie_tomorrow_p = 'A') or (ie_tomorrow_p = 'N' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio >= trunc(clock_timestamp() + interval '2 days')) or (ie_tomorrow_p = 'S' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio < trunc(clock_timestamp() + interval '2 days')));
c_recomendacao CURSOR FOR
SELECT a.nr_sequencia,
    cpoe_obter_desc_item(a.nr_sequencia, 'R') ds_item
from cpoe_recomendacao a,
    cpoe_inf_adic b
where a.nr_sequencia = b.nr_seq_rec_cpoe
and coalesce(b.dt_ack_nurse::text, '') = ''
and coalesce(b.nm_user_ack::text, '') = ''
and (a.nr_atendimento = nr_atendimento_p or (a.nr_sequencia = nr_seq_cpoe_p and ie_tipo_item_p in ('R')))
and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and coalesce(a.dt_lib_suspensao::text, '') = ''
and ((ie_tomorrow_p = 'A') or (ie_tomorrow_p = 'N' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio >= trunc(clock_timestamp() + interval '2 days')) or (ie_tomorrow_p = 'S' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio < trunc(clock_timestamp() + interval '2 days')));
c_anatomia CURSOR FOR
SELECT a.nr_sequencia,
  substr(Obter_Desc_Proc_Interno(nr_seq_proc_interno),1,255) ds_item
from cpoe_anatomia_patologica a,
    cpoe_inf_adic b
where a.nr_sequencia = b.nr_seq_anat_cpoe
and coalesce(b.dt_ack_nurse::text, '') = ''
and coalesce(b.nm_user_ack::text, '') = ''
and (a.nr_atendimento = nr_atendimento_p or (a.nr_sequencia = nr_seq_cpoe_p and ie_tipo_item_p in ('L')))
and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and coalesce(a.dt_lib_suspensao::text, '') = ''
and ((ie_tomorrow_p = 'A') or (ie_tomorrow_p = 'N' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio >= trunc(clock_timestamp() + interval '2 days')) or (ie_tomorrow_p = 'S' and (a.dt_inicio IS NOT NULL AND a.dt_inicio::text <> '') and a.dt_inicio < trunc(clock_timestamp() + interval '2 days')));
BEGIN
for c_dieta_w in c_dieta loop
  ds_alerta_w := substr(ds_alerta_w || c_dieta_w.ds_item || '<br>',1,4000);
end loop;
if (ds_alerta_w IS NOT NULL AND ds_alerta_w::text <> '') and ie_return_desc_p = 'N' then
  return 'S';
end if;

for c_material_w in c_material loop
  ds_alerta_w := substr(ds_alerta_w || c_material_w.ds_item || '<br>',1,4000);
end loop;
if (ds_alerta_w IS NOT NULL AND ds_alerta_w::text <> '') and ie_return_desc_p = 'N' then
  return 'S';
end if;

for c_dialise_w in c_dialise loop
  ds_alerta_w := substr(ds_alerta_w || c_dialise_w.ds_item || '<br>',1,4000);
end loop;
if (ds_alerta_w IS NOT NULL AND ds_alerta_w::text <> '') and ie_return_desc_p = 'N' then
  return 'S';
end if;

for c_gasoterapia_w in c_gasoterapia loop
  ds_alerta_w := substr(ds_alerta_w || c_gasoterapia_w.ds_item || '<br>',1,4000);
end loop;
if (ds_alerta_w IS NOT NULL AND ds_alerta_w::text <> '') and ie_return_desc_p = 'N' then
  return 'S';
end if;

for c_hemoterapia_w in c_hemoterapia loop
  ds_alerta_w := substr(ds_alerta_w || c_hemoterapia_w.ds_item || '<br>',1,4000);
end loop;
if (ds_alerta_w IS NOT NULL AND ds_alerta_w::text <> '') and ie_return_desc_p = 'N' then
  return 'S';
end if;

for c_procedimento_w in c_procedimento loop
  ds_alerta_w := substr(ds_alerta_w || c_procedimento_w.ds_item || '<br>',1,4000);
end loop;
if (ds_alerta_w IS NOT NULL AND ds_alerta_w::text <> '') and ie_return_desc_p = 'N' then
  return 'S';
end if;

for c_recomendacao_w in c_recomendacao loop
  ds_alerta_w := substr(ds_alerta_w || c_recomendacao_w.ds_item || '<br>',1,4000);
end loop;
if (ds_alerta_w IS NOT NULL AND ds_alerta_w::text <> '') and ie_return_desc_p = 'N' then
  return 'S';
end if;

for c_anatomia_w in c_anatomia loop
  ds_alerta_w := substr(ds_alerta_w || c_anatomia_w.ds_item || '<br>',1,4000);
end loop;
if (ds_alerta_w IS NOT NULL AND ds_alerta_w::text <> '') and ie_return_desc_p = 'N' then
  return 'S';
end if;

if ie_return_desc_p = 'S' then
  return ds_alerta_w;
end if;
return 'N';
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_item_pend_lib_nur_enf (nr_atendimento_p bigint, ie_tomorrow_p text, ie_momento_lote_p text, ie_return_desc_p text default 'N', nr_seq_cpoe_p bigint default null, ie_tipo_item_p text default '') FROM PUBLIC;

