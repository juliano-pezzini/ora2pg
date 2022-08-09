-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atuliza_profissional_checkup ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
DECLARE


ie_atualiza_pf_w varchar(1);


BEGIN
	select 	max(ie_atualiza_prof)
	into STRICT	ie_atualiza_pf_w
	from 	checkup_etapa a,
			etapa_checkup b
	where 	a.nr_seq_etapa = b.nr_sequencia
	and 	a.nr_sequencia = nr_sequencia_p;

	if (ie_atualiza_pf_w = 'S') then
		UPDATE 	checkup_etapa
		SET 	cd_pessoa_fisica = cd_pessoa_fisica_p,
				nm_usuario = nm_usuario_p
		WHERE 	nr_sequencia = nr_sequencia_p;
	end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atuliza_profissional_checkup ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;
