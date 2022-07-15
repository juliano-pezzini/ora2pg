-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_desc_anestesica (nr_seq_tecnica_p bigint, nr_cirurgia_p bigint, nr_seq_pepo_p bigint) AS $body$
DECLARE


nr_cirurgia_w		bigint;
nr_seq_pepo_w		bigint;
nr_seq_tecnica_w		bigint;

BEGIN




if (nr_seq_tecnica_p IS NOT NULL AND nr_seq_tecnica_p::text <> '') and
	((nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') or (nr_seq_pepo_p IS NOT NULL AND nr_seq_pepo_p::text <> ''))then

	delete 	from  anestesia_descricao
	where	 	nr_seq_tecnica = nr_seq_tecnica_p
	and		coalesce(dt_liberacao::text, '') = ''
	and 		((coalesce(nr_cirurgia,0) = nr_cirurgia_p) or (coalesce(nr_seq_pepo,0) = nr_seq_pepo_p));
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_desc_anestesica (nr_seq_tecnica_p bigint, nr_cirurgia_p bigint, nr_seq_pepo_p bigint) FROM PUBLIC;

