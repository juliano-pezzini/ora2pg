-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_exame_complemento_mmed ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE




nr_seq_agenda_int_w		bigint;




BEGIN


select	max(a.nr_sequencia)
into STRICT	nr_seq_agenda_int_w
from	agenda_integrada a,
	agenda_integrada_item b
where	b.nr_seq_agenda_int = a.nr_sequencia
and	b.nr_seq_solic_compl = nr_sequencia_p;

/*
select	max(nr_seq_agenda_exame)
into	nr_seq_agenda_exame_w
from	agenda_integrada_item
where	nr_seq_agenda_int = nr_seq_agenda_int_w;

select*/
delete FROM agenda_integrada_item
where	nr_seq_agenda_int = nr_seq_agenda_int_w;

delete	FROM agenda_integrada
where	nr_sequencia	=	nr_seq_agenda_int_w;




commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_exame_complemento_mmed ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
