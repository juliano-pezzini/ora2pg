-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pls_ajustar_estab_web () AS $body$
DECLARE


cd_estabelecimento_ww	varchar(10);
cd_estabelecimento_w	bigint;
qt_registro_w		integer;


BEGIN


select	count(1)
into STRICT	qt_registro_w
from	user_tab_columns
where	table_name 	= 'PLS_WEB_PARAM_GERAL'
and	column_name	= 'CD_ESTABELECIMENTO';

if (qt_registro_w > 0) then
	cd_estabelecimento_ww := pls_obter_param_padrao_funcao(21,1246);

	if (coalesce(cd_estabelecimento_ww::text, '') = '' or cd_estabelecimento_ww = 'X') then
		select	min(cd_estabelecimento)
		into STRICT	cd_estabelecimento_w
		from	pls_outorgante;
	else
		cd_estabelecimento_w := (cd_estabelecimento_ww)::numeric;
	end if;

	update pls_web_param_geral
	set    cd_estabelecimento = cd_estabelecimento_w;


	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pls_ajustar_estab_web () FROM PUBLIC;
