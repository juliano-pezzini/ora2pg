-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_pls_cnae ( nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


cd_cnae_w			varchar(10);
ds_cnae_w			varchar(255);
ds_conteudo_w			varchar(4000);
i				integer;

C01 CURSOR FOR
	SELECT	ds_conteudo
	from	w_pls_interf_cnae;


BEGIN

open C01;
loop
fetch C01 into
	ds_conteudo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (substr(ds_conteudo_w,1,3) = ';;;') and (substr(ds_conteudo_w,1,4) <> ';;;;') then
		cd_cnae_w := substr(ds_conteudo_w,4,7);
		ds_cnae_w := substr(ds_conteudo_w,12,length(ds_conteudo_w)-11);

		insert into w_pls_cnae(cd_cnae,
			ds_cnae,
			nr_sequencia)
		values (cd_cnae_w,
			ds_cnae_w,
			nextval('w_pls_cnae_seq'));
	end if;
	end;
end loop;
close C01;

CALL carregar_w_pls_cnae(nm_usuario_p,cd_estabelecimento_p);
delete 	from w_pls_interf_cnae;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_pls_cnae ( nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
