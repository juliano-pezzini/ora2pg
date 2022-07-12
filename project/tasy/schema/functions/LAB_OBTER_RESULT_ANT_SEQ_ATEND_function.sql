-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_result_ant_seq_atend (nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_exame_p bigint, ie_opcao_p text, nr_seq_anterior_p bigint) RETURNS varchar AS $body$
DECLARE


cd_pessoa_fisica_w		varchar(20);
cd_estabelecimento_w		bigint;
ie_recem_nato_w			varchar(1);

nr_seq_anterior_w	bigint;
nr_prescricao_w		varchar(20);

ds_retorno_w		varchar(2000);

c01 CURSOR FOR
SELECT	row_number() OVER () AS nr_seq_anterior,
		a.nr_prescricao
from (select distinct to_char(a.nr_prescricao) nr_prescricao,
			 a.dt_prescricao
		from	exame_laboratorio d,
		    	exame_lab_result_item c,
			exame_lab_resultado b,
			prescr_medica a
		where	b.nr_seq_resultado	= c.nr_seq_resultado
		and	d.nr_seq_exame 		= c.nr_seq_exame
		and	b.nr_prescricao		= a.nr_prescricao
		and	a.nr_atendimento 	= nr_atendimento_p
		and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w
		and	(obter_data_aprov_lab(b.nr_prescricao,c.nr_seq_prescr) IS NOT NULL AND (obter_data_aprov_lab(b.nr_prescricao,c.nr_seq_prescr))::text <> '')
		and	a.nr_prescricao 	< nr_prescricao_p
		order by a.dt_prescricao desc) a;

BEGIN

select	cd_pessoa_fisica,
	cd_estabelecimento,
	coalesce(ie_recem_nato,'N')
into STRICT	cd_pessoa_fisica_w,
	cd_estabelecimento_w,
	ie_recem_nato_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

open c01;
loop
	fetch c01 into	nr_seq_anterior_w,
			nr_prescricao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	if (nr_seq_anterior_w = nr_seq_anterior_p) then

		if (ie_opcao_p = 'P') then
			ds_retorno_w := nr_prescricao_w;
		elsif (ie_opcao_p = 'DH') then
			select	max(to_char(obter_data_aprov_lab(b.nr_prescricao,c.nr_seq_prescr),'dd/mm/yyyy hh24:mi:ss'))
			into STRICT	ds_retorno_w
			from	exame_laboratorio d,
				exame_lab_result_item c,
				exame_lab_resultado b,
				prescr_medica a
			where	b.nr_seq_resultado	= c.nr_seq_resultado
			and	d.nr_seq_exame 		= c.nr_seq_exame
			and	b.nr_prescricao		= a.nr_prescricao
			and	c.nr_seq_exame		= nr_seq_exame_p
			and	a.nr_prescricao		= nr_prescricao_w
			and	(obter_data_aprov_lab(b.nr_prescricao,c.nr_seq_prescr) IS NOT NULL AND (obter_data_aprov_lab(b.nr_prescricao,c.nr_seq_prescr))::text <> '');
		elsif (ie_opcao_p = 'RM') then
			select	max(coalesce(substr(coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	coalesce(to_char(c.qt_resultado),to_char(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado),1,100),obter_desc_expressao(295406))||' '||substr(obter_lab_unid_med(c.nr_seq_unid_med,'D'),1,40))
			into STRICT	ds_retorno_w
			from	exame_laboratorio d,
				exame_lab_result_item c,
				exame_lab_resultado b,
				prescr_medica a
			where	b.nr_seq_resultado	= c.nr_seq_resultado
			and	d.nr_seq_exame 		= c.nr_seq_exame
			and	b.nr_prescricao		= a.nr_prescricao
			and	c.nr_seq_exame		= nr_seq_exame_p
			and	a.nr_prescricao		= nr_prescricao_w;
			--and	obter_data_aprov_lab(b.nr_prescricao,c.nr_seq_prescr) is not null;
		end if;

	end if;

end loop;
close c01;

return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_result_ant_seq_atend (nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_exame_p bigint, ie_opcao_p text, nr_seq_anterior_p bigint) FROM PUBLIC;

