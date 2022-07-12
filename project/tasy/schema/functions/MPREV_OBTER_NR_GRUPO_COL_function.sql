-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_nr_grupo_col (nr_seq_turma_p bigint) RETURNS bigint AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter o número do grupo coletivo
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:  MedPrev - Programas de Promoção da Saúde.
[  x]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_grupo_w 	bigint;


BEGIN

if (nr_seq_turma_p IS NOT NULL AND nr_seq_turma_p::text <> '')then
	SELECT	nr_seq_grupo_coletivo
	INTO STRICT	nr_grupo_w
	FROM	mprev_grupo_col_turma
	WHERE	nr_sequencia = nr_seq_turma_p;
end if;

return	nr_grupo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_nr_grupo_col (nr_seq_turma_p bigint) FROM PUBLIC;

