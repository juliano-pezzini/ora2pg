-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_desc_turno_dia ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_turno_dia_w	varchar(80);
ds_retorno_w	varchar(4000);

C01 CURSOR FOR
	SELECT	substr(obter_descricao_padrao('HD_TURNO','DS_TURNO',a.nr_seq_turno),1,80)
		||'('||substr(obter_valor_dominio(2766,a.ie_dia_semana),1,255)||')' ds_turno_dia
	from	hd_escala_dialise_dia a,
		hd_escala_dialise b
	where	a.nr_seq_escala = b.nr_sequencia
	and	b.cd_pessoa_fisica = cd_pessoa_fisica_p
	and (b.dt_fim > clock_timestamp() or coalesce(b.dt_fim::text, '') = '');


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	ds_retorno_w := '';

	open C01;
	loop
	fetch C01 into
		ds_turno_dia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		ds_retorno_w	:= ds_retorno_w || ds_turno_dia_w || ',';

		end;
	end loop;
	close C01;

	if (ds_retorno_w <> '') then
		ds_retorno_w	:= substr(ds_retorno_w,1,length(ds_retorno_w)-1);
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_desc_turno_dia ( cd_pessoa_fisica_p text) FROM PUBLIC;
