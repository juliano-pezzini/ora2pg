-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_rev_idiomas_validados ( nr_sequencia_p bigint) AS $body$
DECLARE


nr_seq_filho_w			bigint;
qt_revisao_pendente_w		bigint;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	qua_documento
	where	nr_seq_superior = nr_sequencia_p;


BEGIN

	open c01;
	loop
	fetch c01 into	
		nr_seq_filho_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
			select	count(nr_sequencia)
			into STRICT	qt_revisao_pendente_w
			from	qua_doc_revisao
			where	nr_seq_doc = nr_seq_filho_w
			and	coalesce(dt_validacao::text, '') = ''
			and	coalesce(ie_situacao, 'A') = 'A';

			if qt_revisao_pendente_w > 0 then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(306880);			
			end if;
		end;
	end loop;
	close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_rev_idiomas_validados ( nr_sequencia_p bigint) FROM PUBLIC;

