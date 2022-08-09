-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_anexo_glosa_aut ( cd_glosa_p tiss_motivo_glosa.cd_motivo_tiss%type, nr_seq_lote_guia_imp_p pls_lote_anexo_glosa_aut.nr_seq_lote_guia_imp%type, nr_seq_lote_proc_imp_p pls_lote_anexo_glosa_aut.nr_seq_lote_proc_imp%type, nr_seq_lote_mat_imp_p pls_lote_anexo_glosa_aut.nr_seq_lote_mat_imp%type, ds_observacao_p pls_lote_anexo_glosa_aut.ds_observacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Salvar as glosas geradas no anexo de guia, para a Guia e os itens
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatórios [ ] Outros:
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/nr_seq_motivo_glosa_w	bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_motivo_glosa_w
from	tiss_motivo_glosa
where	cd_motivo_tiss	= cd_glosa_p;

insert into pls_lote_anexo_glosa_aut(	nr_sequencia, nm_usuario, nm_usuario_nrec,
			dt_atualizacao,	dt_atualizacao_nrec, nr_seq_lote_guia_imp,
			nr_seq_lote_proc_imp, nr_seq_lote_mat_imp, nr_seq_motivo_glosa,
			ds_observacao)
		values (	nextval('pls_lote_anexo_glosa_aut_seq'),nm_usuario_p,nm_usuario_p,
			clock_timestamp(),clock_timestamp(),nr_seq_lote_guia_imp_p,
			nr_seq_lote_proc_imp_p,nr_seq_lote_mat_imp_p,nr_seq_motivo_glosa_w,
			ds_observacao_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_anexo_glosa_aut ( cd_glosa_p tiss_motivo_glosa.cd_motivo_tiss%type, nr_seq_lote_guia_imp_p pls_lote_anexo_glosa_aut.nr_seq_lote_guia_imp%type, nr_seq_lote_proc_imp_p pls_lote_anexo_glosa_aut.nr_seq_lote_proc_imp%type, nr_seq_lote_mat_imp_p pls_lote_anexo_glosa_aut.nr_seq_lote_mat_imp%type, ds_observacao_p pls_lote_anexo_glosa_aut.ds_observacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
