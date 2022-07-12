-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_obs_prescr_conduta ( nr_atendimento_p bigint, dt_servico_p timestamp, cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000):= '';
ds_retorno2_w	varchar(80) := '';
nr_seq_apres_w	bigint;

C01 CURSOR FOR
	SELECT	distinct substr(e.ds_observacao, 1, 80),
		coalesce(d.nr_seq_apres,999)
	FROM prescr_dieta e, nut_atend_serv_dia_rep c, nut_atend_serv_dia b, dieta a
LEFT OUTER JOIN dieta_classif d ON (a.nr_seq_classif = d.nr_sequencia)
WHERE c.nr_seq_serv_dia = b.nr_sequencia and c.nr_prescr_oral = e.nr_prescricao and a.cd_dieta = e.cd_dieta  and b.nr_atendimento = nr_atendimento_p and PKG_DATE_UTILS.start_of(b.dt_servico, 'DAY', 0) = PKG_DATE_UTILS.start_of(dt_servico_p, 'DAY', 0) and b.cd_setor_atendimento = cd_setor_atendimento_p and (b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') and coalesce(b.dt_suspensao::text, '') = '' and (e.ds_observacao IS NOT NULL AND e.ds_observacao::text <> '') order by 2,1;
	

BEGIN

open C01;
loop
fetch C01 into	
	ds_retorno2_w,
	nr_seq_apres_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_retorno_w := ds_retorno_w|| ds_retorno2_w||' / ';
	end;
end loop;
close C01;

if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
	ds_retorno_w := substr(ds_retorno_w,1,length(ds_retorno_w)-2);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_obs_prescr_conduta ( nr_atendimento_p bigint, dt_servico_p timestamp, cd_setor_atendimento_p bigint) FROM PUBLIC;

