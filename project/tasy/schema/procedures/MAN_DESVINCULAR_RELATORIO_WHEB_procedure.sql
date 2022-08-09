-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_desvincular_relatorio_wheb ( nr_seq_relatorio_p relatorio.nr_sequencia%type ) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Objective: 
-------------------------------------------------------------------------------------------------------------------
Direct call: 
[  ]  Dictionary objects [  ] Tasy (Delphi/Java/HTML5) [  ] Portal [  ]  Reports [ ] Others:
 ------------------------------------------------------------------------------------------------------------------
Attention points: 
-------------------------------------------------------------------------------------------------------------------
References: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_param_w		man_ordem_servico.nr_seq_localizacao%type;


BEGIN

	if (nr_seq_relatorio_p IS NOT NULL AND nr_seq_relatorio_p::text <> '') then
	begin
		update	relatorio
		set	cd_relatorio_wheb  = NULL,
			cd_classif_relat_wheb  = NULL
		where	nr_sequencia = nr_seq_relatorio_p;
		commit;
	end;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_desvincular_relatorio_wheb ( nr_seq_relatorio_p relatorio.nr_sequencia%type ) FROM PUBLIC;
