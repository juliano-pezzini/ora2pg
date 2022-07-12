-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_blood_allocation_rule_8_ok (ie_tipo_derivado_p text, ie_tipo_sangue_p text, ie_fator_rh_p text, ie_tipo_sangue_paciente_p text, ie_fator_rh_paciente_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(200) := null;
ds_derivado_w varchar(200) := null;
qt_exams_compat_w bigint :=0;
qt_exams_incompat_w bigint :=0;
qt_exams_compat_w2 bigint :=0;
qt_exams_incompat_w2 bigint :=0;


BEGIN

if (coalesce(ie_tipo_sangue_paciente_p::text, '') = '') then
  ds_retorno_w := obter_desc_expressao(1067755);
else

select count(*)
into STRICT qt_exams_compat_w
from san_compat_atipica
where ie_tp_derivado = ie_tipo_derivado_p
and ie_tp_sangue_derivado = ie_tipo_sangue_p
and ie_tp_sangue_paciente = ie_tipo_sangue_paciente_p
and ie_tp_rh_derivado = ie_fator_rh_p
and ie_tp_rh_paciente = ie_fator_rh_paciente_p
and ie_resultado = 'COM';

select count(*)
into STRICT qt_exams_incompat_w
from san_compat_atipica
where ie_tp_derivado = ie_tipo_derivado_p
and ie_tp_sangue_derivado = ie_tipo_sangue_p
and ie_tp_sangue_paciente = ie_tipo_sangue_paciente_p
and ie_tp_rh_derivado = ie_fator_rh_p
and ie_tp_rh_paciente = ie_fator_rh_paciente_p
and ie_resultado = 'INC';

select count(*)
into STRICT qt_exams_compat_w2
from san_compat_atipica
where ie_tp_derivado = ie_tipo_derivado_p
and ie_tp_sangue_derivado = ie_tipo_sangue_p
and ie_tp_sangue_paciente = ie_tipo_sangue_paciente_p
and (ie_tp_rh_derivado = ie_fator_rh_p or coalesce(ie_tp_rh_derivado::text, '') = '')
and (ie_tp_rh_paciente = ie_fator_rh_paciente_p or coalesce(ie_tp_rh_paciente::text, '') = '')
and ie_resultado = 'COM';

select count(*)
into STRICT qt_exams_incompat_w2
from san_compat_atipica
where ie_tp_derivado = ie_tipo_derivado_p
and ie_tp_sangue_derivado = ie_tipo_sangue_p
and ie_tp_sangue_paciente = ie_tipo_sangue_paciente_p
and (ie_tp_rh_derivado = ie_fator_rh_p or coalesce(ie_tp_rh_derivado::text, '') = '')
and (ie_tp_rh_paciente = ie_fator_rh_paciente_p or coalesce(ie_tp_rh_paciente::text, '') = '')
and ie_resultado = 'INC';

if (qt_exams_compat_w > 0) then
    ds_retorno_w := replace(replace(obter_desc_expressao(1041429), '%1', obter_valor_dominio(1341, ie_tipo_derivado_p)),'%2', ie_tipo_sangue_p||ie_fator_rh_p);
elsif (qt_exams_incompat_w > 0) then
    ds_retorno_w := replace(replace(obter_desc_expressao(1041433), '%1', obter_valor_dominio(1341, ie_tipo_derivado_p)),'%2', ie_tipo_sangue_p||ie_fator_rh_p);
elsif (qt_exams_compat_w2 > 0) then
    ds_retorno_w := replace(replace(obter_desc_expressao(1041429), '%1', obter_valor_dominio(1341, ie_tipo_derivado_p)),'%2', ie_tipo_sangue_p||ie_fator_rh_p);
elsif (qt_exams_incompat_w2 > 0) then
    ds_retorno_w := replace(replace(obter_desc_expressao(1041433), '%1', obter_valor_dominio(1341, ie_tipo_derivado_p)),'%2', ie_tipo_sangue_p||ie_fator_rh_p);
elsif (qt_exams_compat_w = 0 and qt_exams_incompat_w = 0 and qt_exams_compat_w2 = 0 and qt_exams_incompat_w2 = 0) then
    ds_retorno_w := obter_desc_expressao(1041511);
end if;
end if;
return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_blood_allocation_rule_8_ok (ie_tipo_derivado_p text, ie_tipo_sangue_p text, ie_fator_rh_p text, ie_tipo_sangue_paciente_p text, ie_fator_rh_paciente_p text) FROM PUBLIC;

