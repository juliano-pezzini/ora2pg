-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_regra_acao_pag_duplic ( nm_usuario_p text) AS $body$
DECLARE


ie_gerar_nc_pag_duplic_w		varchar(1);
cd_estabelecimento_w			smallint;

C01 CURSOR FOR
	SELECT	ie_gerar_nc_pag_duplic,
		cd_estabelecimento
	from	parametro_contas_receber
	where	(ie_gerar_nc_pag_duplic IS NOT NULL AND ie_gerar_nc_pag_duplic::text <> '');


BEGIN
open C01;
loop
fetch C01 into
	ie_gerar_nc_pag_duplic_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	insert into regra_acao_pag_duplic(	nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_estabelecimento,
				dt_inicio_vigencia,
				dt_liberacao,
				ie_acao)
		values (	nextval('regra_acao_pag_duplic_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_estabelecimento_w,
				clock_timestamp(),
				clock_timestamp(),
				'NC');
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_regra_acao_pag_duplic ( nm_usuario_p text) FROM PUBLIC;

