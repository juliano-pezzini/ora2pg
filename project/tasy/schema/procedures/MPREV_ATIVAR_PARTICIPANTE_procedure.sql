-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_ativar_participante (nr_seq_participante_p bigint) AS $body$
DECLARE


ie_status_w	bigint;


BEGIN

if (nr_seq_participante_p IS NOT NULL AND nr_seq_participante_p::text <> '') then

	select 	max(ie_status)
	into STRICT	ie_status_w
	from	mprev_participante
	where	nr_sequencia = nr_seq_participante_p;

	if (ie_status_w = 5) then --Saída (Dominio 6978)
		ie_status_w := 3; -- Acompanhamento (Dominio 6978)
	end if;

	update mprev_participante
	set	ie_situacao = 'A',
		ie_status = coalesce(ie_status_w, ie_status)
	where nr_sequencia = nr_seq_participante_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_ativar_participante (nr_seq_participante_p bigint) FROM PUBLIC;

