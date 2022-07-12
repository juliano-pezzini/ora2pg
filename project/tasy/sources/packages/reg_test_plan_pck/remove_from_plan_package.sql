-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE reg_test_plan_pck.remove_from_plan ( ds_motivo_exclusao_p text, cd_versao_p text, nm_usuario_p text, nr_seq_intencao_uso_p bigint default 2) AS $body$
BEGIN

		update	reg_tc_pendencies tcp
		set	tcp.ds_motivo_exclusao = ds_motivo_exclusao_p,
			tcp.ie_status = 'E',
			tcp.nm_usuario = nm_usuario_p,
			tcp.dt_atualizacao = clock_timestamp()
		where	tcp.nr_seq_controle_plano in (  SELECT  nr_sequencia
                                                from    reg_plano_teste_controle rtc
                                                where   coalesce(rtc.dt_fim_plano::text, '') = ''
                                                    and rtc.dt_inicio_plano <= clock_timestamp()
                                                    and rtc.cd_versao = cd_versao_p
                                                    and coalesce(rtc.nr_seq_intencao_uso,2) = coalesce(nr_seq_intencao_uso_p,2)
                                                    and rtc.ie_situacao = 'A')
		and tcp.nr_sequencia in (	SELECT nr_seq_pendency
									from w_test_plan_ignored_prs i
									where	i.ie_tipo_operacao = 'R'
									and 	i.nm_usuario = nm_usuario_p
									and		i.ds_version = cd_versao_p);

		delete	FROM w_test_plan_ignored_prs
		where	ie_tipo_operacao = 'R'
		and		nm_usuario = nm_usuario_p
		and		ds_version = cd_versao_p;

		commit;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_test_plan_pck.remove_from_plan ( ds_motivo_exclusao_p text, cd_versao_p text, nm_usuario_p text, nr_seq_intencao_uso_p bigint default 2) FROM PUBLIC;
