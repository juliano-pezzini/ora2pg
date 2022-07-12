-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_desc_patologia (nr_seq_diagnostico_p bigint) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Retornar a descrição da patologia pelo código passado.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: MedPrev - Programas de Promoção a Saúde
[ x ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w	varchar(255);


BEGIN

if (nr_seq_diagnostico_p IS NOT NULL AND nr_seq_diagnostico_p::text <> '') then
	select 	ds_diagnostico
	into STRICT	ds_retorno_w
	from 	diagnostico_interno
	where	nr_sequencia = nr_seq_diagnostico_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_desc_patologia (nr_seq_diagnostico_p bigint) FROM PUBLIC;

