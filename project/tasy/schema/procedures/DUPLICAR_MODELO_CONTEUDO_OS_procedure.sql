-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_modelo_conteudo_os ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into modelo_conteudo_os(nr_sequencia,
	nr_seq_modelo,
	nr_seq_perg_visual,
	nr_seq_pergunta,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_apres,
	qt_tamanho,
	ds_label,
	qt_tam_grid,
	qt_altura,
	ds_label_grid,
	ds_mascara,
	ie_readonly,
	ie_obrigatorio,
	ie_tabstop,
	ds_sql,
	qt_desloc_dir,
	qt_pos_esquerda,
	ie_italico,
	ie_negrito,
	ie_sublinhado,
	ds_cor,
	qt_fonte)
	(SELECT	nextval('modelo_conteudo_os_seq'),
		nr_seq_modelo,
		nr_seq_perg_visual,
		nr_seq_pergunta,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_apres + 5,
		qt_tamanho,
		ds_label,
		qt_tam_grid,
		qt_altura,
		ds_label_grid,
		ds_mascara,
		ie_readonly,
		ie_obrigatorio,
		ie_tabstop,
		ds_sql,
		qt_desloc_dir,
		qt_pos_esquerda,
		ie_italico,
		ie_negrito,
		ie_sublinhado,
		ds_cor,
		qt_fonte
	from	modelo_conteudo_os
	where	nr_sequencia	= nr_sequencia_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_modelo_conteudo_os ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

