-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_partic_capt (ds_list_nr_seq_capt_p text) RETURNS varchar AS $body$
DECLARE


list_nr_seq_partic_w    varchar(3500);
nr_seq_partic_w          mprev_participante.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	cd_pessoa_fisica
	from	mprev_captacao
	WHERE Obter_Se_Contido(nr_sequencia, ds_list_nr_seq_capt_p) = 'S';

BEGIN

for r_C01 in C01 loop
	begin
	select 	max(nr_sequencia)
	into STRICT	nr_seq_partic_w
	from 	mprev_participante
	where 	cd_pessoa_fisica = r_C01.cd_pessoa_fisica;

        if (coalesce(list_nr_seq_partic_w::text, '') = '') then
                list_nr_seq_partic_w := nr_seq_partic_w;
        else
                list_nr_seq_partic_w := list_nr_seq_partic_w || ',' || nr_seq_partic_w;
        end if;

	end;
end loop;

return	list_nr_seq_partic_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_partic_capt (ds_list_nr_seq_capt_p text) FROM PUBLIC;

