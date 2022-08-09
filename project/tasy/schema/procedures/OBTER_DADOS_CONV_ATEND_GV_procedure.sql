-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_conv_atend_gv ( cd_pessoa_fisica_p bigint, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, cd_plano_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
cd_convenio_w	integer;
cd_plano_w	varchar(10);
cd_categoria_w	varchar(10);
nr_atendimento_w numeric(25);
						

BEGIN 
 
select	max(a.nr_atendimento) 
into STRICT	nr_atendimento_w 
from	atendimento_paciente a 
where 	a.cd_pessoa_fisica = cd_pessoa_fisica_p;
 
select	max(b.cd_convenio), 
	max(b.cd_plano_convenio), 
	max(b.cd_categoria) 
into STRICT	cd_convenio_w, 
	cd_plano_w, 
	cd_categoria_w 
from	atend_categoria_convenio b 
where	b.nr_atendimento = nr_atendimento_w 
and	b.nr_seq_interno = (SELECT max(c.nr_seq_interno) 
				from atend_categoria_convenio c 
				where c.nr_atendimento = nr_atendimento_w);
				 
cd_convenio_p	:= cd_convenio_w;
cd_plano_p	:= cd_plano_w;
cd_categoria_p	:= cd_categoria_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_conv_atend_gv ( cd_pessoa_fisica_p bigint, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, cd_plano_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
