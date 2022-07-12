-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_smp_pck.gerar_beneficiario ( regra_simulacao_p pls_smp_pck.regra_simulacao, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gerar os dados de beneficiario
	
	Beneficiarios: sera copiado os beneficiarios cadastrados na regra de simulacao
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
insert into pls_smp_result_benef(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_smp,
					nr_seq_segurado)
SELECT	nextval('pls_smp_result_benef_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_smp,
	nr_seq_segurado
from	pls_smp_benef
where	nr_seq_smp	= regra_simulacao_p.nr_sequencia;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_smp_pck.gerar_beneficiario ( regra_simulacao_p pls_smp_pck.regra_simulacao, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;