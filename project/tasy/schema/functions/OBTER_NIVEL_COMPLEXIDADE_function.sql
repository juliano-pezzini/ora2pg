-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nivel_complexidade ( nr_seq_procedimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_nivel_complexidade_w varchar(10);
ie_dominio_w bigint;


BEGIN
	ie_dominio_w := 8693;
	select	obter_descricao_dominio(ie_dominio_w, coalesce(max(ie_nivel_compl), 0))
	into STRICT 	ds_nivel_complexidade_w 
	from 	paciente_compl_assist
	where 	nr_sequencia = nr_seq_procedimento_p;
	
	return	ds_nivel_complexidade_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nivel_complexidade ( nr_seq_procedimento_p bigint) FROM PUBLIC;
