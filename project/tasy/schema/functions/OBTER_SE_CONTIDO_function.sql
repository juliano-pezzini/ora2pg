-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_contido ( qt_valor_p bigint, ds_possib_p text) RETURNS varchar AS $body$
DECLARE


ds_comando_w			varchar(2000);
ds_result_w			varchar(0001);

/*******OBSERVAR QUE O DS_POSSIB_P deve ter o formato (9,4,3) que e gerado pelo sistema de relatorios */

ds_possib_w			varchar(6000);
qt_controle_w			bigint;
qt_pos_separador_w		bigint;
ds_possib_aux_w			varchar(6000);

	--Criado o metodo para evitar erros ao passar valores invalidos para a function
	function obterSeNumeroIgual(	ds_param_p	text) return boolean is
	;
BEGIN
	
	begin
		return( (trim(both ds_param_p))::numeric  = qt_valor_p );
	exception
	when others then
		null;
	end;
	
	return false;
	
	end;

BEGIN

ds_possib_w := trim(both ds_possib_p);

if (position('(' in ds_possib_w) > 0 ) and (position(')' in ds_possib_w) > 0 ) then
	ds_possib_w		:= substr(ds_possib_p,(position('(' in ds_possib_p)+1),(position(')' in ds_possib_p)-2));
end if;

qt_controle_w 		:= 0;
ds_result_w		:= 'N';

qt_pos_separador_w 	:= position(',' in ds_possib_w);

if ( qt_pos_separador_w = 0 ) and (obterSeNumeroIgual(ds_possib_w) ) then
	ds_result_w	:= 'S';
else	
	while( qt_pos_separador_w > 0 )  and ( qt_controle_w < 1000 ) loop
		if ( obterSeNumeroIgual(substr(ds_possib_w,1,qt_pos_separador_w-1)) ) then
			ds_result_w	:= 'S';
			qt_controle_w	:= 1000;
		else
			ds_possib_w		:= substr(ds_possib_w,qt_pos_separador_w+1,length(ds_possib_w));
			qt_pos_separador_w 	:= position(',' in ds_possib_w);
			qt_controle_w		:= qt_controle_w + 1;
		end if;
	end loop;

	if (ds_result_w	= 'N')  and ( obterSeNumeroIgual(ds_possib_w)) then
		ds_result_w	:= 'S';
	end if;

end if;

return ds_result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION obter_se_contido ( qt_valor_p bigint, ds_possib_p text) FROM PUBLIC;

