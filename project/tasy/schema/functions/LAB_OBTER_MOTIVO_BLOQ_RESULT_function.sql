-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_motivo_bloq_result (nr_prescricao_p text, nr_seq_prescr_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_motivo_bloq_resultado_w	varchar(255);
ds_obs_bloq_resultado_w		varchar(255);
ds_retorno_w			varchar(255);
nr_sequencia_w			bigint;

BEGIN
ds_retorno_w := '';
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') then

	select 	MAX(b.nr_seq_motivo_bloqueio),
		MAX(b.ds_obs_bloq_result)
	into STRICT 	nr_sequencia_w,
		ds_obs_bloq_resultado_w
	from	exame_lab_resultado a,
		exame_lab_result_item b
	where 	a.nr_seq_resultado = b.nr_seq_resultado
	and	a.nr_prescricao    = nr_prescricao_p
	and	b.nr_seq_prescr    = nr_seq_prescr_p
	and	(b.nr_seq_material IS NOT NULL AND b.nr_seq_material::text <> '');

	if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		select 	MAX(ds_motivo_bloqueio_result)
		into STRICT	ds_motivo_bloq_resultado_w
		from 	lab_motivo_bloqueio_result
		where	nr_sequencia = nr_sequencia_w;
	end if;

	if (ie_opcao_p = 1) then
		ds_retorno_w := ds_motivo_bloq_resultado_w;
	elsif (ie_opcao_p = 2) then
		ds_retorno_w := ds_obs_bloq_resultado_w;
	end if;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_motivo_bloq_result (nr_prescricao_p text, nr_seq_prescr_p text, ie_opcao_p text) FROM PUBLIC;

