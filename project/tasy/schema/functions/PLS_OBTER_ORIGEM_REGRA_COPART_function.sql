-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_origem_regra_copart (nr_seq_coparticipacao_p pls_conta_coparticipacao.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Verifica se a coparticipacao é oriunda de recurso de glosa ou conta médica
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w	varchar(255);
qt_item_rec_w	bigint;

BEGIN

select	count(1)
into STRICT	qt_item_rec_w
from	pls_conta_coparticipacao
where	nr_sequencia = nr_seq_coparticipacao_p
and	((nr_seq_mat_rec IS NOT NULL AND nr_seq_mat_rec::text <> '') or (nr_seq_proc_rec IS NOT NULL AND nr_seq_proc_rec::text <> ''));

	if (coalesce(qt_item_rec_w,0) > 0) then
		ds_retorno_w := 'Recurso de Glosa';
	else
		ds_retorno_w := 'Conta Médica';
	end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_origem_regra_copart (nr_seq_coparticipacao_p pls_conta_coparticipacao.nr_sequencia%type) FROM PUBLIC;

