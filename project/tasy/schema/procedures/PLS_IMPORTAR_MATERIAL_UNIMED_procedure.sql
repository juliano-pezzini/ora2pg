-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_importar_material_unimed ( cd_material_p bigint, cd_unidade_medida_p text, ie_origem_p text, nm_material_p text, ie_tipo_p bigint, ie_situacao_p text, cd_cnpj_p text, nm_fabricante_p text, nm_importador_p text, nr_registro_anvisa_p text, ds_motivo_ativo_inativo_p text, ds_material_p text, ds_especialidade_p text, ds_classe_p text, ds_apresentacao_p text, ie_generico_p text, dt_inicio_obrigatorio_p text, ds_grupo_farmacologico_p text, ds_classe_farmacologico_p text, ds_forma_farmaceutico_p text, ds_principio_ativo_p text, pr_icms_p bigint, vl_pmc_p bigint, vl_fator_conversao_p bigint, vl_fabrica_p bigint, vl_max_consumidor_p bigint, dt_validade_anvisa_p text, nr_seq_lote_imp_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_situacao_w		varchar(1)	:= 'A';
nr_seq_mat_unimed_w	bigint;



BEGIN
select	coalesce(max(ie_situacao),'X')
into STRICT	ie_situacao_w
from	pls_material_unimed
where	cd_material	= cd_material_p;

if (ie_situacao_p	= '1') then /* Ativo */
	if (ie_situacao_w	= 'X') then
		select	nextval('pls_material_unimed_seq')
		into STRICT	nr_seq_mat_unimed_w
		;

		insert into pls_material_unimed(nr_sequencia,
			cd_material,
			cd_unidade_medida,
			ie_origem,
			nm_material,
			ie_tipo,
			ie_situacao,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_cnpj,
			nm_fabricante,
			nm_importador,
			nr_registro_anvisa,
			ds_motivo_ativo_inativo,
			ds_material,
			ds_especialidade,
			ds_classe,
			ds_apresentacao,
			ie_generico,
			dt_inicio_obrigatorio,
			ds_grupo_farmacologico,
			ds_classe_farmacologico,
			ds_forma_farmaceutico,
			ds_principio_ativo,
			pr_icms,
			vl_pmc,
			vl_fator_conversao,
			vl_fabrica,
			vl_max_consumidor,
			dt_validade_anvisa,
			cd_estabelecimento)
		values (	nr_seq_mat_unimed_w,
			substr(cd_material_p,1,10),
			substr(cd_unidade_medida_p,1,10),
			substr(ie_origem_p,1,1),
			substr(nm_material_p,1,255),
			substr(ie_tipo_p,1,3),
			'A',
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			substr(cd_cnpj_p,1,14),
			substr(nm_fabricante_p,1,255),
			substr(nm_importador_p,1,255),
			substr(nr_registro_anvisa_p,1,20),
			substr(ds_motivo_ativo_inativo_p,1,255),
			substr(ds_material_p,1,2000),
			substr(ds_especialidade_p,1,255),
			substr(ds_classe_p,1,255),
			substr(ds_apresentacao_p,1,2000),
			substr(ie_generico_p,1,1),
			to_date(dt_inicio_obrigatorio_p,'yyyy-mm-dd'),
			substr(ds_grupo_farmacologico_p,1,255),
			substr(ds_classe_farmacologico_p,1,255),
			substr(ds_forma_farmaceutico_p,1,255),
			substr(ds_principio_ativo_p,1,255),
			pr_icms_p,
			vl_pmc_p,
			vl_fator_conversao_p,
			vl_fabrica_p,
			vl_max_consumidor_p,
			to_date(dt_validade_anvisa_p,'yyyy-mm-dd'),
			wheb_usuario_pck.get_cd_estabelecimento);

			if (nr_seq_lote_imp_p IS NOT NULL AND nr_seq_lote_imp_p::text <> '') then
				insert into pls_lote_imp_mat_uni_reg(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_lote,
					nr_seq_mat_unimed,
					ie_tipo_alteracao)
				values (nextval('pls_lote_imp_mat_uni_reg_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_lote_imp_p,
					nr_seq_mat_unimed_w,
					'I');
			end if;

	elsif (ie_situacao_w	= 'I') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_mat_unimed_w
		from	pls_material_unimed
		where	cd_material 	= cd_material_p;

		update	pls_material_unimed
		set	ie_situacao	= 'A',
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	cd_material	= cd_material_p;

		if (nr_seq_lote_imp_p IS NOT NULL AND nr_seq_lote_imp_p::text <> '') then
			insert into pls_lote_imp_mat_uni_reg(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_lote,
				nr_seq_mat_unimed,
				ie_tipo_alteracao)
			values (nextval('pls_lote_imp_mat_uni_reg_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_lote_imp_p,
				nr_seq_mat_unimed_w,
				'A');
		end if;
	end if;
elsif (ie_situacao_p	= '2') then /* Inativo */
	if (ie_situacao_w	= 'A') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_mat_unimed_w
		from	pls_material_unimed
		where	cd_material 	= cd_material_p;

		update	pls_material_unimed
		set	ie_situacao	= 'I',
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	cd_material	= cd_material_p;

		if (nr_seq_lote_imp_p IS NOT NULL AND nr_seq_lote_imp_p::text <> '') then
			insert into pls_lote_imp_mat_uni_reg(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_lote,
				nr_seq_mat_unimed,
				ie_tipo_alteracao)
			values (nextval('pls_lote_imp_mat_uni_reg_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_lote_imp_p,
				nr_seq_mat_unimed_w,
				'E');
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_importar_material_unimed ( cd_material_p bigint, cd_unidade_medida_p text, ie_origem_p text, nm_material_p text, ie_tipo_p bigint, ie_situacao_p text, cd_cnpj_p text, nm_fabricante_p text, nm_importador_p text, nr_registro_anvisa_p text, ds_motivo_ativo_inativo_p text, ds_material_p text, ds_especialidade_p text, ds_classe_p text, ds_apresentacao_p text, ie_generico_p text, dt_inicio_obrigatorio_p text, ds_grupo_farmacologico_p text, ds_classe_farmacologico_p text, ds_forma_farmaceutico_p text, ds_principio_ativo_p text, pr_icms_p bigint, vl_pmc_p bigint, vl_fator_conversao_p bigint, vl_fabrica_p bigint, vl_max_consumidor_p bigint, dt_validade_anvisa_p text, nr_seq_lote_imp_p bigint, nm_usuario_p text) FROM PUBLIC;
