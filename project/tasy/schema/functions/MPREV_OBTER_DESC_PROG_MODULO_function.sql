-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_desc_prog_modulo (nr_seq_prog_modulo_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Retorna o nome do módulo que está vinculado ao programa
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w	mprev_modulo_atend.ds_modulo%type;


BEGIN

if (nr_seq_prog_modulo_p IS NOT NULL AND nr_seq_prog_modulo_p::text <> '') then
	select	b.ds_modulo
	into STRICT	ds_retorno_w
	from	mprev_modulo_atend b,
		mprev_programa_modulo a
	where	a.nr_seq_modulo	= b.nr_sequencia
	and	a.nr_sequencia	= nr_seq_prog_modulo_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_desc_prog_modulo (nr_seq_prog_modulo_p bigint) FROM PUBLIC;
