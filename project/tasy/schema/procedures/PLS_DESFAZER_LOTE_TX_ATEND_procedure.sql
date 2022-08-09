-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_lote_tx_atend ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Desfazer o lote de taxa de atendimetno
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
	OPS - Controle de Coparticipações e Pós-estabelecidos
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

delete	from	pls_lib_taxa_atend
where	nr_seq_lote	= nr_seq_lote_p;

update	pls_lote_taxa_atend
set	dt_geracao		 = NULL,
	nm_usuario_geracao	 = NULL,
	ie_status		= 'P'
where	nr_sequencia		= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_lote_tx_atend ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
