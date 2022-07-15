-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_imp_depara_material_me () AS $body$
DECLARE


cd_estabelecimento_w			estabelecimento.cd_estabelecimento%type;
ds_estabelecimento_w			pessoa_juridica.ds_razao_social%type;
cd_material_w				conv_mat_sistema_externo.cd_material%type;
cd_sistema_externo_w			conv_mat_sistema_externo.cd_sistema_externo%type;
nr_seq_regra_w				bigint;

c01 CURSOR FOR
SELECT	distinct
	cd_estabelecimento,
	substr(obter_nome_estabelecimento(cd_estabelecimento),1,200)
from	conv_mat_sistema_externo;

c02 CURSOR FOR
SELECT	cd_material,
	cd_sistema_externo
from	conv_mat_sistema_externo
where	cd_estabelecimento = cd_estabelecimento_w
and	((clock_timestamp() between dt_inicio_vigencia and dt_fim_vigencia) or (coalesce(dt_inicio_vigencia::text, '') = '' or coalesce(dt_fim_vigencia::text, '') = ''));


BEGIN

open C01;
loop
fetch C01 into
	cd_estabelecimento_w,
	ds_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('regra_conv_meio_ext_seq')
	into STRICT	nr_seq_regra_w
	;

	insert into regra_conv_meio_ext(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_regra,
		ie_situacao)
	values (	nr_seq_regra_w,
		clock_timestamp(),
		'Tasy',
		clock_timestamp(),
		'Tasy',
		substr('ME - ' || ds_estabelecimento_w,1,80),
		'A');

	open C02;
	loop
	fetch C02 into
		cd_material_w,
		cd_sistema_externo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		insert into conversao_meio_externo(
			cd_cgc,
			nm_tabela,
			nm_atributo,
			cd_interno,
			cd_externo,
			dt_atualizacao,
			nm_usuario,
			nr_sequencia,
			ie_sistema_externo,
			nr_seq_regra,
			ie_envio_receb,
			nm_apresentacao_ext,
			cd_dominio)
		values (	null,
			'MATERIAL',
			'CD_MATERIAL',
			cd_material_w,
			cd_sistema_externo_w,
			clock_timestamp(),
			'Tasy',
			nextval('conversao_meio_externo_seq'),
			null,
			nr_seq_regra_w,
			'A',
			null,
			null);
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_imp_depara_material_me () FROM PUBLIC;

