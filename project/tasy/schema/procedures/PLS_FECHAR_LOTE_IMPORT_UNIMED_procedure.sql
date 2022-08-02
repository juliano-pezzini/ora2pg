-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_fechar_lote_import_unimed ( nm_usuario_p text, nr_seq_lote_p bigint ) AS $body$
DECLARE


qt_inconsistencias_w	bigint;
qt_nao_importados_w	bigint;


BEGIN
	select	count(*)
	into STRICT	qt_inconsistencias_w
	from	pls_lote_importacao_unimed	a,
		pls_w_import_cad_unimed		b
	where	a.nr_sequencia			= b.nr_seq_lote
	and	b.nr_seq_lote			= nr_seq_lote_p
	and	b.ds_inconsistencia 		= 12;

	if (qt_inconsistencias_w	> 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(265256,'');
		--Mensagem: Existem registros com inconsistências, o lote não pode ser fechado!
	end if;

	select	count(*)
	into STRICT	qt_nao_importados_w
	from	pls_lote_importacao_unimed	a,
		pls_w_import_cad_unimed		b
	where	a.nr_sequencia			= b.nr_seq_lote
	and	b.nr_seq_lote			= nr_seq_lote_p
	and	b.ie_existente = 'N'
	and	coalesce(b.dt_importacao::text, '') = '';

	if (qt_nao_importados_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(265257,'');
		--Mensagem: Há registros ainda não importados, o lote não pode ser fechado!
	end if;

	update	pls_lote_importacao_unimed
	set	dt_fechamento	= clock_timestamp()
	where	nr_sequencia	= nr_seq_lote_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_fechar_lote_import_unimed ( nm_usuario_p text, nr_seq_lote_p bigint ) FROM PUBLIC;

