-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_lag_consistir_guia_mat ( nr_seq_lote_guia_imp_p bigint, nr_seq_guia_plano_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Consistir se o 'Material, inativo ou fora de vigência'e Consistir se o 'Material informado não coberto'.
-------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_lote_mat_imp_w	bigint;
nr_seq_guia_plano_w	pls_guia_plano.nr_sequencia%type;
qt_registro_w		integer;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_material,
		nr_seq_plano_mat
	from	pls_lote_anexo_mat_imp
	where	nr_seq_lote_guia_imp	= nr_seq_lote_guia_imp_p;

BEGIN

select	nr_seq_guia
into STRICT	nr_seq_guia_plano_w
from	pls_lote_anexo_guias_imp
where	nr_sequencia			= nr_seq_lote_guia_imp_p;

for	r_C01_w in C01 loop

	--Se não encontrar o procedimento na base gera a glosa 2001 - Material inválido
	--A sequência do material da guia é obtido na importação do XML na procedure PLS_SALVAR_LT_AX_MAT_AUT
	if ( coalesce(r_C01_w.nr_seq_plano_mat::text, '') = '' ) then
		CALL pls_inserir_anexo_glosa_aut('2001', nr_seq_lote_guia_imp_p,  null, r_C01_w.nr_sequencia, 'Material/medicamento não encontrado na guia referência no anexo', nm_usuario_p);
	end if;

end loop;

/* Consistir a glosa '2006' */

--pls_lag_consistir_cobert_mat(nr_seq_lote_guia_imp_p, nr_seq_lote_mat_imp_w, nr_seq_guia_plano_p, nm_usuario_p);
/* Consistir a glosa '9920' por material */

--pls_lag_consistir_atv_vig_mat(nr_seq_lote_guia_imp_p, nr_seq_lote_mat_imp_w, nr_seq_guia_plano_p, nm_usuario_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_lag_consistir_guia_mat ( nr_seq_lote_guia_imp_p bigint, nr_seq_guia_plano_p bigint, nm_usuario_p text) FROM PUBLIC;
