-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_atend_usu_conv_duplic (cd_pessoa_fisica_p bigint, cd_usuario_convenio_p text) RETURNS varchar AS $body$
DECLARE

 
/* 
busca todos os atendimentos de determinado usuário com determinado número de convênio 
*/
 
 
nr_atendimento_w bigint;
qt_total_atendimentos_w varchar(5000);

c01 CURSOR FOR 
	SELECT	a.nr_atendimento 
	from	atendimento_paciente a, 
			atend_categoria_convenio b 
	where	a.nr_atendimento = b.nr_atendimento 
	and		a.cd_pessoa_fisica = cd_pessoa_fisica_p 
	and		b.cd_usuario_convenio = cd_usuario_convenio_p;
	

BEGIN 
open c01;
loop 
fetch	c01 into nr_atendimento_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
 
		qt_total_atendimentos_w := qt_total_atendimentos_w || nr_atendimento_w ||', ';
 
		end;
end loop;
close c01;
 
	qt_total_atendimentos_w := substr(qt_total_atendimentos_w, 1, length(qt_total_atendimentos_w)-2);
 
 
 
return	qt_total_atendimentos_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_atend_usu_conv_duplic (cd_pessoa_fisica_p bigint, cd_usuario_convenio_p text) FROM PUBLIC;
