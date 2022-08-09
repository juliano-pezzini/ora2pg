-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_lote_copartic ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Desfazer o lote de coparticipação
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
	OPS - Controle de Coparticipações
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_lib_copartic_w		pls_lib_coparticipacao.nr_sequencia%type;
nr_seq_conta_coparticipacao_w	pls_conta_coparticipacao.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_conta_coparticipacao
	from	pls_lib_coparticipacao
	where	nr_seq_lote	= nr_seq_lote_p;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_lib_copartic_w,
	nr_seq_conta_coparticipacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	update	pls_conta_coparticipacao
	set	vl_copartic_mens	 = NULL,
		tx_copartic_mens	 = NULL,
		nr_seq_regra_limite_copartic	 = NULL
	where	nr_sequencia		= nr_seq_conta_coparticipacao_w;

	delete	from	pls_coparticipacao_critica
	where	nr_seq_lib_copartic	= nr_seq_lib_copartic_w;

	delete	from	pls_lib_coparticipacao
	where	nr_sequencia	= nr_seq_lib_copartic_w;
	end;
end loop;
close C01;

update	pls_lote_coparticipacao
set	dt_geracao		 = NULL,
	nm_usuario_geracao	 = NULL,
	ie_status		= 'P',
	dt_inicio_geracao	 = NULL,
	dt_fim_geracao		 = NULL,
	hr_geracao_lote		 = NULL
where	nr_sequencia		= nr_seq_lote_p;

CALL pls_gravar_hist_lote_copartic(	nr_seq_lote_p,
				'Desfazer lote',
				nm_usuario_p,
				cd_estabelecimento_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_lote_copartic ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
