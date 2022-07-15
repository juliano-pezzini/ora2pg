-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_funcoes_consultor (nr_sequencia_consultor_p bigint) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_modulo_w		bigint;
ie_tipo_consultor_w	varchar(5);

c01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_mod_impl
	from	com_cons_gest_con_mod
	where	nr_seq_consultor = nr_sequencia_consultor_p
	and	coalesce(nr_seq_gest_con::text, '') = '';


BEGIN
select	max(CASE WHEN coalesce(ie_tipo_consultor,'A')='CO' THEN 'O' WHEN coalesce(ie_tipo_consultor,'A')='CP' THEN 'P'  ELSE 'A' END )
into STRICT	ie_tipo_consultor_w
from	com_canal_consultor
where	nr_sequencia = nr_sequencia_consultor_p;

open c01;
loop
fetch c01 into
	nr_sequencia_w,
	nr_seq_modulo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	CALL Com_Gerar_Funcao_Conhecimento(nr_sequencia_w,nr_seq_modulo_w,'Tasy',ie_tipo_consultor_w);
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_funcoes_consultor (nr_sequencia_consultor_p bigint) FROM PUBLIC;

