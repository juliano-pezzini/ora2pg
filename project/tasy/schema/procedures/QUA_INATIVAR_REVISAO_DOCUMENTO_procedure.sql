-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_inativar_revisao_documento (nr_seq_revisao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_doc_w	bigint;


BEGIN
	if (obter_se_base_corp = 'S'
		or	obter_se_base_wheb = 'S') then
		begin
			update	qua_doc_revisao
			set	ie_situacao = 'I',
				nm_usuario_inativacao = nm_usuario_p,
				dt_inativacao = clock_timestamp()
			where	nr_sequencia = nr_seq_revisao_p
			and	coalesce(ie_situacao, 'A') = 'A';
			
			select	nr_seq_doc
			into STRICT	nr_seq_doc_w
			from	qua_doc_revisao
			where	nr_sequencia = nr_seq_revisao_p
			and	coalesce(ie_situacao, 'A') = 'A';
			
			if (nr_seq_doc_w IS NOT NULL AND nr_seq_doc_w::text <> '') then
				CALL qua_atualizar_status_doc(nr_seq_doc_w, 'D', nm_usuario_p);
			end if;
			commit;
		end;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_inativar_revisao_documento (nr_seq_revisao_p bigint, nm_usuario_p text) FROM PUBLIC;

