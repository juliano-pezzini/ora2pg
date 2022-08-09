-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vinc_titulo_pagar_a580 ( nr_seq_fat_geral_p ptu_fatura_geral.nr_sequencia%type, nr_titulo_apagar_p ptu_fatura_geral.nr_titulo_pagar%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Vincula um titulo a pagar diretamente na fatura A580

		Apenas vinucla o titulo, não deve gerar novo.

		Esta ação é utilizada principalmente pelo processo de camara nacional, onde a Unimed Brasil
		emite um A580 no fechamento de uma câmara.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN


if (nr_seq_fat_geral_p IS NOT NULL AND nr_seq_fat_geral_p::text <> '') and (nr_titulo_apagar_p IS NOT NULL AND nr_titulo_apagar_p::text <> '') then

	update	ptu_fatura_geral
	set	nr_titulo_pagar	= nr_titulo_apagar_p,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia 	= nr_seq_fat_geral_p;

end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vinc_titulo_pagar_a580 ( nr_seq_fat_geral_p ptu_fatura_geral.nr_sequencia%type, nr_titulo_apagar_p ptu_fatura_geral.nr_titulo_pagar%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
