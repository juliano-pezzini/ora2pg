-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_desc_programa (nr_seq_programa_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Finalidade: Retornar a descrição do programa.

-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: MedPrev - Pesquisa de População Alvo

[ x ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:

 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w	varchar(255);




BEGIN



if (nr_seq_programa_p IS NOT NULL AND nr_seq_programa_p::text <> '') then

	select 	nm_programa

	into STRICT	ds_retorno_w

	from 	mprev_programa

	where	nr_sequencia = nr_seq_programa_p;

end if;



return	ds_retorno_w;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_desc_programa (nr_seq_programa_p bigint) FROM PUBLIC;

