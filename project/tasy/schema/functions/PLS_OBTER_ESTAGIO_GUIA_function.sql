-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_estagio_guia ( nr_seq_guia_p bigint) RETURNS bigint AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Obter o estágio da guia de autorização
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ds_retorno_w	smallint;


BEGIN

if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	select 	max(ie_estagio)
	into STRICT	ds_retorno_w
	from 	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_estagio_guia ( nr_seq_guia_p bigint) FROM PUBLIC;

