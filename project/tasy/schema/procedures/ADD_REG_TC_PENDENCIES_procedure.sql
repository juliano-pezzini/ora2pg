-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE add_reg_tc_pendencies ( nm_usuario_p text, nr_seq_tc_p bigint, cd_version_p text) AS $body$
DECLARE

	cd_funcao_w		varchar(10);
	nr_seq_pr_w		bigint;
	nr_seq_controle_plano_w	bigint;
	nr_result_w		smallint;
	nr_seq_script_w		bigint;
	ds_sql_w		varchar(4000);
	ds_params_w		varchar(255);
    nr_seq_intencao_uso_w reg_caso_teste.nr_seq_intencao_uso%type;

BEGIN
	select	max(pr.nr_sequencia),
		max(ctf.cd_funcao),
		max(ct.nr_seq_test_script)
	into STRICT	nr_seq_pr_w,
		cd_funcao_w,
		nr_seq_script_w
	from	reg_product_requirement pr,
		reg_caso_teste_funcao ctf,
		reg_caso_teste ct
	where	ct.nr_sequencia	= ctf.nr_seq_caso_teste
	and	pr.nr_sequencia	= ct.nr_seq_product
	and	ct.nr_sequencia	= nr_seq_tc_p
	and (ct.dt_liberacao_vv IS NOT NULL AND ct.dt_liberacao_vv::text <> '')
	and (ct.dt_aprovacao IS NOT NULL AND ct.dt_aprovacao::text <> '');
	
	ds_sql_w :=	'select	1 '
		||	'from	schem_test_script@schematic4test sts '
		||	'where	sts.nr_sequencia = :nr_seq_script '
		||	'and	to_number(substr(:cd_version, 6, 4)) >= to_number(sts.ds_version)';
	
	ds_params_w := 'nr_seq_script=' || nr_seq_script_w||';cd_version=' ||cd_version_p;
	
	nr_result_w := obter_valor_dinamico_bv(ds_sql_w, ds_params_w, nr_result_w);
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_controle_plano_w
	from	reg_plano_teste_controle
	where	cd_versao = cd_version_p
	and	coalesce(dt_fim_plano::text, '') = '';
	
	if (	(nr_seq_pr_w IS NOT NULL AND nr_seq_pr_w::text <> '')
		and	nr_result_w > 0)	then
		
        select coalesce(nr_seq_intencao_uso, 2)
          into STRICT nr_seq_intencao_uso_w
          from reg_caso_teste
         where nr_sequencia = nr_seq_tc_p;

		if (coalesce(nr_seq_controle_plano_w::text, '') = '')	then
			
			select	nextval('reg_plano_teste_controle_seq')
			into STRICT	nr_seq_controle_plano_w
			;
			
			insert
			into reg_plano_teste_controle(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ie_situacao,
					cd_versao,
					dt_inicio_plano,
					dt_fim_plano,
                    nr_seq_intencao_uso
				)
				values (
					nr_seq_controle_plano_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					'A',
					cd_version_p,
					clock_timestamp(),
					null,
                    nr_seq_intencao_uso_w
				);
		end if;
		
		insert
		into reg_tc_pendencies(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_tc,
				nr_seq_pr,
				ds_version,
				cd_funcao,
				ie_status,
				ie_tipo_mudanca,
				nr_seq_controle_plano,
                nr_seq_intencao_uso
			)
			values (
				nextval('reg_tc_pendencies_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_tc_p,
				nr_seq_pr_w,
				cd_version_p,
				cd_funcao_w,
				'P',
				'SP',
				nr_seq_controle_plano_w,
                nr_seq_intencao_uso_w
			);
		commit;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE add_reg_tc_pendencies ( nm_usuario_p text, nr_seq_tc_p bigint, cd_version_p text) FROM PUBLIC;

