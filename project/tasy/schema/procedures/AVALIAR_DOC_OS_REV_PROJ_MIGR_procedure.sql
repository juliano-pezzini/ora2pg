-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE avaliar_doc_os_rev_proj_migr ( nr_seq_os_p bigint, ie_avaliacao_p text, ie_analise_p text, ds_analise_p text, ds_pontos_positivos_p text, ds_pontos_negativos_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_documentacao_w	bigint;


BEGIN
if (nr_seq_os_p IS NOT NULL AND nr_seq_os_p::text <> '') and (ie_avaliacao_p IS NOT NULL AND ie_avaliacao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_documentacao_w
	from	w_migracao_ordem_servico
	where	nr_seq_os_migracao = nr_seq_os_p;

	if (nr_seq_documentacao_w > 0) then
		begin
		update	w_migracao_ordem_servico
		set	ie_avaliacao = ie_avaliacao_p,
			ie_analise_avaliacao = ie_analise_p,
			ds_analise_avaliacao = ds_analise_p,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p,
			dt_avaliacao = clock_timestamp(),
			ds_pontos_positivos = ds_pontos_positivos_p,
			ds_pontos_negativos = ds_pontos_negativos_p
		where	nr_sequencia = nr_seq_documentacao_w;
		end;
	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE avaliar_doc_os_rev_proj_migr ( nr_seq_os_p bigint, ie_avaliacao_p text, ie_analise_p text, ds_analise_p text, ds_pontos_positivos_p text, ds_pontos_negativos_p text, nm_usuario_p text) FROM PUBLIC;
