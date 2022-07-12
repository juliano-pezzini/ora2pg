-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_classif_agenda_pac ( nr_seq_classif_agenda_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_classificacao_w	varchar(80);


BEGIN

if (nr_seq_classif_agenda_p > 0) then
	select		max(ds_classificacao)
	into STRICT		ds_classificacao_w
	from   		agenda_paciente_classif
	where		nr_sequencia	=	nr_seq_classif_agenda_p;
end if;

return ds_classificacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_classif_agenda_pac ( nr_seq_classif_agenda_p bigint ) FROM PUBLIC;
