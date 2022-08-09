-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE finalizar_qua_doc_log_acesso ( nr_seq_doc_p bigint, nm_usuario_p text, ie_doc_resp_p text) AS $body$
DECLARE


nr_seq_doc_inf_w		bigint := 0;
nr_seq_superior_w		bigint := 0;
ie_doc_pai_w			varchar(1);

C01 CURSOR FOR
SELECT	nr_sequencia
from	qua_documento
where	nr_seq_superior = nr_seq_superior_w;


BEGIN
if (nr_seq_doc_p IS NOT NULL AND nr_seq_doc_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
		update	qua_doc_log_acesso
		set	dt_fim_leitura = clock_timestamp(),
			ie_doc_resp = ie_doc_resp_p
		where	nr_seq_doc = nr_seq_doc_p
		and	nm_usuario = nm_usuario_p
		and	coalesce(dt_fim_leitura::text, '') = ''
		and	dt_leitura > clock_timestamp() - interval '3 days';

		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
		into STRICT	ie_doc_pai_w
		from	qua_documento a
		where	a.nr_sequencia = nr_seq_doc_p
		and	coalesce(a.nr_seq_superior::text, '') = '';

		if (ie_doc_pai_w = 'S') then
			nr_seq_superior_w := nr_seq_doc_p;
		else
			begin
				select	nr_seq_superior
				into STRICT	nr_seq_superior_w
				from	qua_documento
				where	nr_sequencia = nr_seq_doc_p;

				update	qua_doc_log_acesso
				set	dt_fim_leitura = clock_timestamp(),
					ie_doc_resp = ie_doc_resp_p
				where	nr_seq_doc = nr_seq_superior_w
				and	nm_usuario = nm_usuario_p
				and	coalesce(dt_fim_leitura::text, '') = ''
				and	dt_leitura > clock_timestamp() - interval '3 days';
			end;
		end if;

		open C01;
		loop
		fetch C01 into
			nr_seq_doc_inf_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			update	qua_doc_log_acesso
			set	dt_fim_leitura = clock_timestamp(),
				ie_doc_resp = ie_doc_resp_p
			where	nr_seq_doc = nr_seq_doc_inf_w
			and	nm_usuario = nm_usuario_p
			and	coalesce(dt_fim_leitura::text, '') = ''
			and	dt_leitura > clock_timestamp() - interval '3 days';
		end;
		end loop;
		close C01;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE finalizar_qua_doc_log_acesso ( nr_seq_doc_p bigint, nm_usuario_p text, ie_doc_resp_p text) FROM PUBLIC;
