-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_classif_encaixe_agenda (nr_seq_classif_p INOUT bigint) AS $body$
DECLARE


nr_seq_classif_w	bigint;



BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_classif_w
from	agenda_paciente_classif
where	ie_tipo_classif	= 'E'
and	ie_situacao	= 'A';

if (nr_seq_classif_w = 0) then

	select	coalesce(max(nr_sequencia),0) + 1
	into STRICT	nr_seq_classif_w
	from	agenda_paciente_classif;

	insert	into agenda_paciente_classif(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		ds_classificacao,
		ie_tipo_classif,
		ie_situacao)
	values (nr_seq_classif_w,
		clock_timestamp(),
		'TASY',
		wheb_mensagem_pck.get_texto(802118),
		'E', 'A');

end if;

nr_seq_classif_p	:= nr_seq_classif_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_classif_encaixe_agenda (nr_seq_classif_p INOUT bigint) FROM PUBLIC;
