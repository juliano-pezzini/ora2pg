-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fleury_is_etiqueta_fleury ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ds_unidade_fleury_p text, ds_controle_p text, ds_seq_etiqueta_p text) RETURNS varchar AS $body$
DECLARE




ie_existe_w                varchar(1) := 'N';
ie_agrupa_ficha_fleury_w   lab_parametro.ie_agrupa_ficha_fleury%type;

cd_barras_w                bigint;
nr_seq_etiqueta_w          bigint;

ie_suspenso_w				varchar(1);




BEGIN

cd_barras_w          := obter_somente_numero(ds_controle_p);
nr_seq_etiqueta_w    := obter_somente_numero(ds_seq_etiqueta_p);

select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
into STRICT	ie_suspenso_w
from	prescr_medica a,
		prescr_procedimento b
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao = nr_prescricao_p
and		b.nr_sequencia = nr_seq_prescr_p
and		coalesce(coalesce(a.dt_suspensao, b.dt_suspensao)::text, '') = '';

if (ie_suspenso_w = 'S') then
	select CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
	into STRICT ie_existe_w
	from	prescr_proc_controle_etiq a
	where	coalesce(a.cd_barras::text, '') = ''
	and   a.nr_controle	= cd_barras_w
	and	a.nr_seq_etiqueta = nr_seq_etiqueta_w
	and   a.nr_seq_prescr = nr_seq_prescr_p
	and   a.nr_prescricao = nr_prescricao_p;
end if;

return ie_existe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fleury_is_etiqueta_fleury ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ds_unidade_fleury_p text, ds_controle_p text, ds_seq_etiqueta_p text) FROM PUBLIC;
