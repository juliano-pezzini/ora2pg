-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_seq_conselho_tiss (ds_conselho_p text) RETURNS bigint AS $body$
DECLARE


/*
Essa rotina só pode ser utilizada na versão 3.01.00 do TISS, onde o domino do conselhor profissional foi alterado no schema do XML
*/
nr_sequencia_w	conselho_profissional.nr_sequencia%type;
sg_conselho_w	conselho_profissional.sg_conselho%type;
nr_conselho_w	smallint;

BEGIN

nr_conselho_w	:= (ds_conselho_p)::numeric;
case(nr_conselho_w)
	when 1 	then
		sg_conselho_w := 'CRAS';
	when 2 	then
		sg_conselho_w := 'COREN';
	when 3 then
		sg_conselho_w := 'CRF';
	when 4 then
		sg_conselho_w := 'CRFA';
	when 5 then
		sg_conselho_w := 'CREFITO';
	when 6 then
		sg_conselho_w := 'CRM';
	when 7 then
		sg_conselho_w := 'CRN';
	when 8 then
		sg_conselho_w := 'CRO';
	when 9 then
		sg_conselho_w := 'CRP';
	when 10 then
		sg_conselho_w := 'OUT';
	else
		sg_conselho_w := null;
end case;

if (sg_conselho_w IS NOT NULL AND sg_conselho_w::text <> '') then
	select	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from	conselho_profissional
	where	sg_conselho = sg_conselho_w;
end if;


return	nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_seq_conselho_tiss (ds_conselho_p text) FROM PUBLIC;
