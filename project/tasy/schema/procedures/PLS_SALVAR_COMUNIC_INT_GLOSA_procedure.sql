-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_salvar_comunic_int_glosa ( nr_seq_comunicado_p bigint, cd_glosa_p text, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Salvar as glosas no comunicação de internação
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [ X ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

insert	into	pls_comunic_int_glosa(nr_sequencia, nr_seq_comunicado_int, dt_atualizacao,
				      nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				      cd_glosa)
			       values (nextval('pls_comunic_int_glosa_seq'), nr_seq_comunicado_p, clock_timestamp(),
				      nm_usuario_p, clock_timestamp(), nm_usuario_p,
				      cd_glosa_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_salvar_comunic_int_glosa ( nr_seq_comunicado_p bigint, cd_glosa_p text, nm_usuario_p text) FROM PUBLIC;

