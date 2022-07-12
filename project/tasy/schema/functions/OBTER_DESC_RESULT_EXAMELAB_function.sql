-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_result_examelab ( nr_resultcol_p bigint, nm_usuario_p text, nr_sequencia_p bigint ) RETURNS varchar AS $body$
DECLARE

dt_result timestamp;
hr_result varchar(20);
ds_resultado_w varchar(100) := '';
dth varchar(50);
qt_reg_w	bigint;

BEGIN
  select count(1)
  into STRICT   qt_reg_w
  from W_RESULT_EXAME_GRID
  where ie_ordem = -3
    and nm_usuario = nm_usuario_p;

if (qt_reg_w > 0) then

  --datas
  select
    CASE WHEN nr_resultcol_p =1 THEN  to_date(max(DS_RESULT1), 'dd/mm/yyyy hh24:mi:ss') WHEN nr_resultcol_p =2 THEN  to_date(max(DS_RESULT2), 'dd/mm/yyyy hh24:mi:ss') WHEN nr_resultcol_p =3 THEN  to_date(max(DS_RESULT3), 'dd/mm/yyyy hh24:mi:ss') WHEN nr_resultcol_p =4 THEN  to_date(max(DS_RESULT4), 'dd/mm/yyyy hh24:mi:ss') WHEN nr_resultcol_p =5 THEN  to_date(max(DS_RESULT5), 'dd/mm/yyyy hh24:mi:ss') WHEN nr_resultcol_p =6 THEN  to_date(max(DS_RESULT6), 'dd/mm/yyyy hh24:mi:ss') END  as dt
  into STRICT
    dt_result
  from W_RESULT_EXAME_GRID
  where ie_ordem = -3
    and nm_usuario = nm_usuario_p;

  --horas
  select

    substr(CASE WHEN nr_resultcol_p =1 THEN  max(DS_RESULT1) WHEN nr_resultcol_p =2 THEN  max(DS_RESULT2) WHEN nr_resultcol_p =3 THEN  max(DS_RESULT3) WHEN nr_resultcol_p =4 THEN  max(DS_RESULT4) WHEN nr_resultcol_p =5 THEN  max(DS_RESULT5) WHEN nr_resultcol_p =6 THEN  max(DS_RESULT6)  END ,1,20) as hr
  into STRICT
    hr_result
  from W_RESULT_EXAME_GRID
  where ie_ordem = -7
    and nm_usuario = nm_usuario_p;

  --select/retorno
  dth :=  to_char(dt_result,'dd/mm/yy') || ' ' ||   hr_result;


  select substr(max(ds_referencia),1,100)
  into STRICT ds_resultado_w
  from w_result_exame_ref
  where nr_seq_result = nr_sequencia_p
    and to_char(dt_resultado,'dd/mm/yy hh24:mi') = dth;
end if;

 return ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_result_examelab ( nr_resultcol_p bigint, nm_usuario_p text, nr_sequencia_p bigint ) FROM PUBLIC;

