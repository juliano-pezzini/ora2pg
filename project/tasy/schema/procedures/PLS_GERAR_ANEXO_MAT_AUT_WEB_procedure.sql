-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_anexo_mat_aut_web (nr_registro_anvisa_p text, cd_ref_fabricante_p text, dt_prevista_p timestamp, ie_via_administracao_p text, qt_solicitado_p bigint, ie_opcao_fabricante_p bigint, nr_seq_lote_anexo_guia_p bigint, nr_seq_plano_mat_p bigint, cd_aut_funcionamento_p text, ie_frequencia_dose_p bigint, qt_unidade_medida_p text, qt_dosagem_total_p bigint, nm_usuario_p text) AS $body$
BEGIN


insert	into	pls_lote_anexo_mat_aut( nr_sequencia, nr_registro_anvisa, cd_ref_fabricante_imp,
					dt_prevista, ie_via_administracao, qt_solicitado,
					ie_opcao_fabricante, nr_seq_lote_anexo_guia, nr_seq_plano_mat,
					nm_usuario, nm_usuario_nrec, dt_atualizacao,
					dt_atualizacao_nrec, cd_aut_funcionamento, ie_frequencia_dose,
					qt_unidade_medida, qt_dosagem_total)
				values (nextval('pls_lote_anexo_mat_aut_seq'), nr_registro_anvisa_p, cd_ref_fabricante_p,
					dt_prevista_p, ie_via_administracao_p, qt_solicitado_p,
					ie_opcao_fabricante_p, nr_seq_lote_anexo_guia_p, nr_seq_plano_mat_p,
					nm_usuario_p, nm_usuario_p, clock_timestamp(),
					clock_timestamp(), cd_aut_funcionamento_p, ie_frequencia_dose_p,
					qt_unidade_medida_p, qt_dosagem_total_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_anexo_mat_aut_web (nr_registro_anvisa_p text, cd_ref_fabricante_p text, dt_prevista_p timestamp, ie_via_administracao_p text, qt_solicitado_p bigint, ie_opcao_fabricante_p bigint, nr_seq_lote_anexo_guia_p bigint, nr_seq_plano_mat_p bigint, cd_aut_funcionamento_p text, ie_frequencia_dose_p bigint, qt_unidade_medida_p text, qt_dosagem_total_p bigint, nm_usuario_p text) FROM PUBLIC;
