-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_passagem_setor (nr_atendimento_p bigint, cd_setor_p text) RETURNS varchar AS $body$
DECLARE


qt_reg_w	integer	:= 0;
cd_setor_w	varchar(255);
ds_setor_w	varchar(255);
vl_pos_w	smallint;


BEGIN

ds_setor_w	:= substr(cd_setor_p,1,255);

while(qt_reg_w = 0) and (length(ds_setor_w) > 0) loop
	begin

	vl_pos_w	:= position(',' in ds_setor_w);

	if (vl_pos_w > 0) then
		cd_setor_w	:= substr(ds_setor_w, 1,		(vl_pos_w - 1));
		ds_setor_w	:= substr(ds_setor_w, (vl_pos_w + 1),	length(ds_setor_w));
	else
		cd_setor_w	:= ds_setor_w;
		ds_setor_w	:= '';
	end	if;

	select	count(*)
	into STRICT	qt_reg_w
	from	atend_paciente_unidade
	where	cd_setor_atendimento 	= cd_setor_w
	and	nr_atendimento		= nr_atendimento_p;
	exception
		when others then
			qt_reg_w	:= 0;

	end;
end loop;

if (qt_reg_w > 0) then
	return	'S';
else
	return	'N';
end if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_passagem_setor (nr_atendimento_p bigint, cd_setor_p text) FROM PUBLIC;
