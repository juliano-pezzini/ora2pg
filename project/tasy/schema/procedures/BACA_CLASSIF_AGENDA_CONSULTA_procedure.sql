-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_classif_agenda_consulta () AS $body$
DECLARE


cd_classificacao_w		varchar(05);
ds_classificacao_w		varchar(40);
ie_tipo_classif_w		varchar(01);

c01 CURSOR FOR
	SELECT	a.vl_dominio,
		a.ds_valor_dominio
	from	valor_dominio a
	where	a.cd_dominio	= 1006
	and	not exists (SELECT	1
		from	agenda_classif x
		where	x.cd_classificacao	= a.vl_dominio);


BEGIN

open	c01;
loop
fetch	c01 into
	cd_classificacao_w,
	ds_classificacao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (cd_classificacao_w	= 'R') then
		ie_tipo_classif_w	:= 'R';
	elsif (cd_classificacao_w	= 'X') then
		ie_tipo_classif_w	:= 'E';
	else
		ie_tipo_classif_w	:= 'C';
	end if;

	insert	into agenda_classif(cd_classificacao,
		ds_classificacao,
		dt_atualizacao,
		nm_usuario,
		ie_tipo_classif,
		ds_cor_fundo,
		ds_cor_fonte,
		ie_agenda,
		ie_situacao)
	values (cd_classificacao_w,
		ds_classificacao_w,
		clock_timestamp(),
		'TASY',
		ie_tipo_classif_w,
		null,
		null,
		'A',
		'A');

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_classif_agenda_consulta () FROM PUBLIC;

