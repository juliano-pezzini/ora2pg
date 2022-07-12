-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_is_so_in_agreement ( nr_seq_acordo_p bigint, nr_seq_ordem_serv_p bigint ) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionário [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------

Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		varchar(4000);


BEGIN
	
	select	coalesce(max('S'), 'N')
	into STRICT	ds_retorno_w
	from	desenv_acordo_os dao
	where	dao.nr_seq_acordo = nr_seq_acordo_p
	and	dao.nr_seq_ordem_servico = nr_seq_ordem_serv_p;
	
	return ds_retorno_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_is_so_in_agreement ( nr_seq_acordo_p bigint, nr_seq_ordem_serv_p bigint ) FROM PUBLIC;

