-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Procedure que realiza a consistncia dos procedimentos lanados na contas mdicas



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.consistir_proc_envio_ans ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE



--Varivel table para controlar a insero das inconsistncias

tb_nr_seq_cta_val_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_cta_proc_val_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_cta_mat_val_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_lote_w		pls_util_cta_pck.t_number_table;
tb_cd_inconsistencia_w		pls_util_cta_pck.t_varchar2_table_20;
qt_registro_w 			integer := 0;
qt_pacote_tab_w			integer := 0;
nr_seq_processo_w		pls_monitor_tempo_lote.nr_sequencia%type;


C01 CURSOR(	nr_seq_lote_pc	pls_monitor_tiss_lote.nr_sequencia%type )  FOR
	SELECT	a.nr_sequencia,
		b.nr_sequencia nr_seq_cta_val,
		a.cd_grupo_proc,
		a.cd_tabela_ref,
		a.ie_origem_proced,
		coalesce(a.vl_procedimento,0) vl_apresentado,
		coalesce(a.qt_procedimento,0) qt_procedimento
	from	pls_monitor_tiss_proc_val a,
		pls_monitor_tiss_cta_val b
	where	a.nr_seq_cta_val 	= b.nr_sequencia
	and	b.nr_seq_lote_monitor	= nr_seq_lote_pc;

BEGIN

nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	nr_seq_lote_p, 'Consistindo procedimentos do lote', 'I', nm_usuario_p, nr_seq_processo_w);

qt_registro_w := 0;

--Percorre todas os procedimentos que sero consistidos

for	r_C01_w in C01( nr_seq_lote_p ) loop

	--INC001 - Cdigo do grupo de procedimento ANS no informado

	if ( coalesce(r_C01_w.cd_grupo_proc::text, '') = '' ) then

		tb_nr_seq_cta_val_w(qt_registro_w)	:= r_C01_w.nr_seq_cta_val;
		tb_nr_seq_cta_proc_val_w(qt_registro_w)	:= r_C01_w.nr_sequencia;
		tb_nr_seq_cta_mat_val_w(qt_registro_w)	:= null;
		tb_nr_seq_lote_w(qt_registro_w)		:= null;
		tb_cd_inconsistencia_w(qt_registro_w)	:= 'INC001';
		qt_registro_w := qt_registro_w + 1;

	end if;

	--INC006 - Cdigo tabela referncia no informado

	if ( coalesce(r_C01_w.cd_tabela_ref::text, '') = '' ) then

		tb_nr_seq_cta_val_w(qt_registro_w)	:= r_C01_w.nr_seq_cta_val;
		tb_nr_seq_cta_proc_val_w(qt_registro_w)	:= r_C01_w.nr_sequencia;
		tb_nr_seq_cta_mat_val_w(qt_registro_w)	:= null;
		tb_nr_seq_lote_w(qt_registro_w)		:= null;
		tb_cd_inconsistencia_w(qt_registro_w)	:= 'INC006';
		qt_registro_w := qt_registro_w + 1;
	end if;

	--INC011 - Origem procedimento no informada

	if ( coalesce(r_C01_w.ie_origem_proced::text, '') = '' ) then
		tb_nr_seq_cta_val_w(qt_registro_w)	:= r_C01_w.nr_seq_cta_val;
		tb_nr_seq_cta_proc_val_w(qt_registro_w)	:= r_C01_w.nr_sequencia;
		tb_nr_seq_cta_mat_val_w(qt_registro_w)	:= null;
		tb_nr_seq_lote_w(qt_registro_w)		:= null;
		tb_cd_inconsistencia_w(qt_registro_w)	:= 'INC011';
		qt_registro_w := qt_registro_w + 1;
	end if;

	select	count(1)
	into STRICT	qt_pacote_tab_w
	from	pls_moni_tiss_item_pac_val
	where	nr_seq_cta_val_proc	= r_C01_w.nr_sequencia
	and	coalesce(cd_tabela_ref::text, '') = '';

	--INC026 - Cdigo tabela referncia no informado para algum item do pacote

	if (qt_pacote_tab_w > 0) then
		tb_nr_seq_cta_val_w(qt_registro_w)	:= r_C01_w.nr_seq_cta_val;
		tb_nr_seq_cta_proc_val_w(qt_registro_w)	:= r_C01_w.nr_sequencia;
		tb_nr_seq_cta_mat_val_w(qt_registro_w)	:= null;
		tb_nr_seq_lote_w(qt_registro_w)		:= null;
		tb_cd_inconsistencia_w(qt_registro_w)	:= 'INC026';
		qt_registro_w := qt_registro_w + 1;
	end if;

	--INC032 - Quantidade apresentada do procedimento deve ser maior que zero

	if ( r_C01_w.qt_procedimento <= 0 ) then
		tb_nr_seq_cta_val_w(qt_registro_w)	:= r_C01_w.nr_seq_cta_val;
		tb_nr_seq_cta_proc_val_w(qt_registro_w)	:= r_C01_w.nr_sequencia;
		tb_nr_seq_cta_mat_val_w(qt_registro_w)	:= null;
		tb_nr_seq_lote_w(qt_registro_w)		:= null;
		tb_cd_inconsistencia_w(qt_registro_w)	:= 'INC032';
		qt_registro_w := qt_registro_w + 1;
	end if;

	/* conforme combinado entre Dcio e Leonardo essa inconssistncia fica desabilitada pelo motivo que existem alguns clientes
	   com valor apresentado zero e isso ser uma verdade perante o processo executado
	--INC012 - Valor apresentado no informado

	if	( r_C01_w.vl_apresentado = 0 ) then
		tb_nr_seq_cta_val_w(qt_registro_w)	:= r_C01_w.nr_seq_cta_val;
		tb_nr_seq_cta_proc_val_w(qt_registro_w)	:= r_C01_w.nr_sequencia;
		tb_nr_seq_cta_mat_val_w(qt_registro_w)	:= null;
		tb_cd_inconsistencia_w(qt_registro_w)	:= 'INC012';
		qt_registro_w := qt_registro_w + 1;
	end if;
	*/


	if ( qt_registro_w >= pls_util_pck.qt_registro_transacao_w ) then
		CALL CALL CALL pls_gerencia_envio_ans_pck.gravar_inconsistencia( tb_nr_seq_cta_val_w, tb_nr_seq_cta_proc_val_w, tb_nr_seq_cta_mat_val_w, tb_cd_inconsistencia_w, tb_nr_seq_lote_w, nm_usuario_p );
		--zera as variveis

		qt_registro_w := 0;
		tb_nr_seq_cta_val_w.delete;
		tb_nr_seq_cta_proc_val_w.delete;
		tb_nr_seq_cta_mat_val_w.delete;
		tb_cd_inconsistencia_w.delete;
		tb_nr_seq_lote_w.delete;
	end if;

end loop;

--se sobrou registros, manda pro banco

CALL CALL CALL pls_gerencia_envio_ans_pck.gravar_inconsistencia( tb_nr_seq_cta_val_w, tb_nr_seq_cta_proc_val_w, tb_nr_seq_cta_mat_val_w, tb_cd_inconsistencia_w, tb_nr_seq_lote_w, nm_usuario_p );

--zera as variveis

tb_nr_seq_cta_val_w.delete;
tb_nr_seq_cta_proc_val_w.delete;
tb_nr_seq_cta_mat_val_w.delete;
tb_cd_inconsistencia_w.delete;
tb_nr_seq_lote_w.delete;

nr_seq_processo_w := pls_gerencia_envio_ans_pck.grava_log_tempo_processo(	null, null, 'F', null, nr_seq_processo_w);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.consistir_proc_envio_ans ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
