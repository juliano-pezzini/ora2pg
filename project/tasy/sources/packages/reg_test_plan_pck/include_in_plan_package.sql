-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE reg_test_plan_pck.include_in_plan ( nm_usuario_p text, ds_versao_p text default null) AS $body$
DECLARE


	nr_seq_controle_plano_w		reg_tc_pendencies.nr_seq_controle_plano%type;

	
BEGIN

		select	max(nr_sequencia)
		into STRICT	nr_seq_controle_plano_w
		from	reg_plano_teste_controle
		where	cd_versao = ds_versao_p
		and	ie_situacao = 'A';

		if (nr_seq_controle_plano_w IS NOT NULL AND nr_seq_controle_plano_w::text <> '') then

			insert into reg_tc_pendencies(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_pr,
				nr_seq_tc,
				ds_version,
				cd_funcao,
				ie_status,
				ie_tipo_mudanca,
				nr_seq_controle_plano )
			SELECT	nextval('reg_tc_pendencies_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_product_req,
				nr_seq_caso_teste,
				ds_versao_p,
				cd_funcao,
				'P',
				'I',
				nr_seq_controle_plano_w
			from	w_test_plan_ignored_prs
			where	ie_tipo_operacao = 'I'
			and	nm_usuario = nm_usuario_p;

			delete	FROM w_test_plan_ignored_prs
			where	ie_tipo_operacao = 'I'
			and	nm_usuario = nm_usuario_p;

		end if;

		commit;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_test_plan_pck.include_in_plan ( nm_usuario_p text, ds_versao_p text default null) FROM PUBLIC;
