-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_filtro_justificativa ( ie_justificativa_p text, ie_excedeu_p text, ie_excedeu_anual_p text, dt_referencia_p timestamp, cd_empresa_p bigint, nm_usuario_p text) AS $body$
DECLARE


					
c01			integer;
ds_comando_w 		varchar(4000) := '';
cd_classif_conta_w	varchar(40);
retorno_w		integer;
cd_classificacao_ww	varchar(50);
					

BEGIN

ds_comando_w := 'Select cd_classificacao ' ||
		'from 	w_ctb_acomp_orcamento ' ||
		'where	nm_usuario = :nm_usuario_p';

if (ie_justificativa_p = 1) then
	ds_comando_w := ds_comando_w ||  ' and ds_justificativa is not null';
elsif (ie_justificativa_p = 2) then
	ds_comando_w := ds_comando_w ||  ' and ds_justificativa is null';
end if;

if (ie_excedeu_p = 1) then
	ds_comando_w := ds_comando_w || '  and ie_status_just in (2,4,6) ';
elsif (ie_excedeu_p = 2) then
	ds_comando_w := ds_comando_w || '  and ie_status_just not in (2,4)';
end if;

if (ie_excedeu_anual_p = 'S') then
	ds_comando_w := ds_comando_w || '  and ie_excedeu_anual = ''S'' ';
end if;

c01 := dbms_sql.open_cursor;
dbms_sql.parse(c01, ds_comando_w, dbms_sql.native);
dbms_sql.define_column(c01, 1, cd_classif_conta_w, 40);
dbms_sql.bind_variable(c01, 'nm_usuario_p', nm_usuario_p);
retorno_w	:= dbms_sql.execute(c01);


while(dbms_sql.fetch_rows(c01) > 0 ) loop
	dbms_sql.column_value(c01, 1,cd_classif_conta_w);
	
	
	cd_classificacao_ww := '';
	
	
	cd_classificacao_ww	:= substr(ctb_obter_classif_conta_sup(cd_classif_conta_w, dt_referencia_p, cd_empresa_p),1,40);
	
	while(cd_classificacao_ww IS NOT NULL AND cd_classificacao_ww::text <> '') loop
		cd_classif_conta_w := cd_classificacao_ww;

		update 	w_ctb_acomp_orcamento
		set	ie_status_just = 6	
		where	nm_usuario = nm_usuario_p
		and	cd_classificacao = cd_classificacao_ww
		and	coalesce(cd_centro_custo::text, '') = '';
		
		cd_classificacao_ww	:= substr(ctb_obter_classif_conta_sup(cd_classificacao_ww, dt_referencia_p, cd_empresa_p),1,40);
		
		if (cd_classificacao_ww = cd_classif_conta_w) then
			cd_classificacao_ww := null;
		end if;
	end loop;
	
end loop;

dbms_sql.close_cursor(c01);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_filtro_justificativa ( ie_justificativa_p text, ie_excedeu_p text, ie_excedeu_anual_p text, dt_referencia_p timestamp, cd_empresa_p bigint, nm_usuario_p text) FROM PUBLIC;

