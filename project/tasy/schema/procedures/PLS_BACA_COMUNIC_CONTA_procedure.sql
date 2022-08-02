-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_comunic_conta ( nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

			 
 
cd_perfil_w			bigint;
cd_perfil_comunic_w	 	bigint;
nm_usuario_param_w		varchar(30);

C01 CURSOR FOR 
	SELECT 	nm_usuario_param 
	from	funcao_param_usuario 
	where 	cd_funcao = 1208 
	and	nr_sequencia = 23;

C02 CURSOR FOR 
	SELECT	cd_perfil 
	from 	funcao_param_perfil 
	where	cd_funcao = 1208 
	and	nr_sequencia = 23;

BEGIN
 
select	max(cd_perfil_comunic_integr) 
into STRICT	cd_perfil_comunic_w 
from	pls_parametros 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
if (cd_perfil_comunic_w IS NOT NULL AND cd_perfil_comunic_w::text <> '') then 
	insert into pls_conta_comunic_interna(nr_sequencia, ds_comunicado, ds_titulo, 
		dt_atualizacao, dt_atualizacao_nrec, ie_situacao, 
		ie_tipo_regra, nm_usuario, nm_usuario_nrec, 
		cd_perfil) 
	values (nextval('pls_conta_comunic_interna_seq'), ' ', 'Confirmação de integração de protocolo de contas médicas', 
		clock_timestamp(), clock_timestamp(), 'A', 
		1,nm_usuario_p, nm_usuario_p, 
		cd_perfil_comunic_w);
end if;
 
open C01;
loop 
fetch C01 into	 
	nm_usuario_param_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	insert into pls_conta_comunic_interna(nr_sequencia, ds_comunicado, ds_titulo, 
		dt_atualizacao, dt_atualizacao_nrec, ie_situacao, 
		ie_tipo_regra, nm_usuario, nm_usuario_nrec, 
		nm_usuario_comunic) 
	values (nextval('pls_conta_comunic_interna_seq'), ' ', 'Protocolo liberado', 
		clock_timestamp(), clock_timestamp(), 'A', 
		2,nm_usuario_p, nm_usuario_p, 
		nm_usuario_param_w);
	end;
end loop;
close C01;
commit;
 
open C02;
loop 
fetch C02 into	 
	cd_perfil_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	insert into pls_conta_comunic_interna(nr_sequencia, ds_comunicado, ds_titulo, 
		dt_atualizacao, dt_atualizacao_nrec, ie_situacao, 
		ie_tipo_regra, nm_usuario, nm_usuario_nrec, 
		cd_perfil) 
	values (nextval('pls_conta_comunic_interna_seq'), ' ', 'Protocolo liberado', 
		clock_timestamp(), clock_timestamp(), 'A', 
		2,nm_usuario_p, nm_usuario_p, 
		cd_perfil_w);
	end;
end loop;
close C02;
 
 
delete 	FROM funcao_param_hist 
where 	cd_funcao	= 1208 
and	nr_seq_param	= 23;
 
delete 	FROM funcao_parametro 
where	cd_funcao	= 1208 
and	nr_sequencia	= 23;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_comunic_conta ( nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

