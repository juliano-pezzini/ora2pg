-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_cd_seq_congenere_web ( nr_seq_congenere_p INOUT bigint, cd_congenere_p INOUT text, ds_congenere_p INOUT text) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Obter código ou sequência do beneficiário congênere
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [ X ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/BEGIN

if (nr_seq_congenere_p IS NOT NULL AND nr_seq_congenere_p::text <> '') then
	select	max(cd_cooperativa)
	into STRICT		cd_congenere_p
	from	pls_congenere
	where	nr_sequencia	= nr_seq_congenere_p;
elsif (cd_congenere_p IS NOT NULL AND cd_congenere_p::text <> '') then
	select	max(nr_sequencia)
	into STRICT		nr_seq_congenere_p
	from	pls_congenere
	where	cd_cooperativa	= cd_congenere_p;
end if;

if (nr_seq_congenere_p IS NOT NULL AND nr_seq_congenere_p::text <> '') then
	ds_congenere_p  := pls_obter_nome_congenere(nr_seq_congenere_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_cd_seq_congenere_web ( nr_seq_congenere_p INOUT bigint, cd_congenere_p INOUT text, ds_congenere_p INOUT text) FROM PUBLIC;
