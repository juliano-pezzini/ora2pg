-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_recomendacao_prescr (nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_recomendacao_w	varchar(4000) := '';
ds_recomendacao_ww	varchar(255);
qt_recomendacao_w	smallint;
cd_recomendacao_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	prescr_recomendacao
	where	nr_prescricao = nr_prescricao_p;


BEGIN
select	count(*)
into STRICT	qt_recomendacao_w
from 	prescr_recomendacao
where 	nr_prescricao = nr_prescricao_p;

if (qt_recomendacao_w > 0) then

	open C01;
	loop
	fetch C01 into
		cd_recomendacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	substr(obter_desc_tipo_recomendacao(cd_recomendacao),1,255)|| obter_desc_expressao(285555)/*' |  Complemento - '*/
 ||' - '||
			substr(ds_recomendacao,1,255) ||obter_desc_expressao(292190)/*' | Intervalo - '*/
 ||' - '|| substr(OBTER_DESC_INTERVALO(cd_intervalo),1,255) ds_intervalo
		into STRICT	ds_recomendacao_ww
		from 	prescr_recomendacao
		where 	nr_prescricao = nr_prescricao_p
		and	nr_sequencia = cd_recomendacao_w;

		ds_recomendacao_w := (ds_recomendacao_w || ds_recomendacao_ww || chr(13) || chr(13));
		end;
	end loop;
	close C01;

end if;

return	ds_recomendacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_recomendacao_prescr (nr_prescricao_p bigint) FROM PUBLIC;

