-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_69_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) AS $body$
DECLARE


_ora2pg_r RECORD;
nr_seq_selecao_w	pls_util_cta_pck.t_number_table;
ds_observacao_w		pls_util_cta_pck.t_varchar2_table_4000;
ie_valido_w		pls_util_cta_pck.t_varchar2_table_1;
ds_obs_texto_w		varchar(255);

C01 CURSOR(	nr_seq_oc_cta_comb_p	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	a.ie_conta_sem_item ie_conta_sem_item
	from	pls_oc_cta_val_proc_mat a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

C02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_sequencia%type) FOR
	SELECT 	x.nr_sequencia,
		'S' ie_valido,
		ds_obs_texto_w ds_observacao
	from	pls_oc_cta_selecao_imp	x
	where	x.ie_valido		= 'S'
	and	x.nr_id_transacao	= nr_id_transacao_pc
	and 	not exists (	SELECT	1
				from 	pls_conta_item_imp y
				where	y.nr_seq_conta = x.nr_seq_conta);

BEGIN

if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '')  then
	CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', 'N', nr_id_transacao_p, null);
	for r_C01_w in C01(nr_seq_combinada_p) loop
		if (r_C01_w.ie_conta_sem_item = 'S')	then

			SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	nr_seq_selecao_w, ie_valido_w, ds_observacao_w ) INTO STRICT _ora2pg_r;
 	nr_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; ie_valido_w := _ora2pg_r.tb_ie_valido_p; ds_observacao_w  := _ora2pg_r.tb_ds_observacao_p;

			ds_obs_texto_w	:= wheb_mensagem_pck.get_texto(780326);

			open c02(nr_id_transacao_p);
			loop
				fetch 	c02 bulk collect
				into	nr_seq_selecao_w,ie_valido_w,ds_observacao_w
				limit pls_util_cta_pck.qt_registro_transacao_w;
				exit when nr_seq_selecao_w.count = 0;

				CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	nr_seq_selecao_w, ie_valido_w,
										ds_observacao_w, nr_id_transacao_p,
										'SEQ');

			end loop;
			close c02;
		end if;
	end loop;
	CALL pls_ocor_imp_pck.atualiza_campo_valido('V', 'N',
						ie_regra_excecao_p, null,
						nr_id_transacao_p, null);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_69_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) FROM PUBLIC;
