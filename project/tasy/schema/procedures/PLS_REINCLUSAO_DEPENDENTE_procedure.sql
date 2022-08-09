-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_reinclusao_dependente ( nr_seq_reinclusao_p bigint, nr_seq_segurado_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Inserir a reinclusão de beneficiários dependentes do titular que foi reincluso.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  x ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN


	insert into pls_reinc_dependentes(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,
						nm_usuario_nrec,nr_seq_reinc_benef,nr_seq_segurado )
	values (	nextval('pls_reinc_dependentes_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),
						nm_usuario_p,nr_seq_reinclusao_p,nr_seq_segurado_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reinclusao_dependente ( nr_seq_reinclusao_p bigint, nr_seq_segurado_p bigint, nm_usuario_p text) FROM PUBLIC;
