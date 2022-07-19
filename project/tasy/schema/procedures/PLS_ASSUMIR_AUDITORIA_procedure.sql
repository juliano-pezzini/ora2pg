-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_assumir_auditoria ( nr_seq_grupo_auditor_p bigint, nr_sequencia_p bigint, nr_seq_ordem_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_grupo_auditor_w		varchar(10);
qt_auditoria_grupo_w	bigint;
nr_seq_grupo_auditor_w	bigint;


BEGIN
if (nr_seq_grupo_auditor_p IS NOT NULL AND nr_seq_grupo_auditor_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_seq_ordem_p IS NOT NULL AND nr_seq_ordem_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin

	select	coalesce(pls_obter_se_auditor_grupo(nr_seq_grupo_auditor_p,nm_usuario_p),'N')
	into STRICT	ie_grupo_auditor_w
	;

	if (ie_grupo_auditor_w = 'S') then
		begin

		select	count(*)
		into STRICT	qt_auditoria_grupo_w
		from	pls_auditoria_grupo
		where	nr_seq_auditoria = nr_sequencia_p
		and	nr_seq_ordem < nr_seq_ordem_p
		and	coalesce(dt_liberacao::text, '') = '';

		if (qt_auditoria_grupo_w = 0) then
			begin

			select	pls_obter_grupo_analise_atual(nr_sequencia_p)
			into STRICT	nr_seq_grupo_auditor_w
			;

			CALL pls_assumir_grupo_auditoria(
				nr_seq_grupo_auditor_w,
				nm_usuario_p);

			end;
		else
			begin
			--Não é possivel assumir a auditoria do grupo, pois existem grupos anteriores que não encerraram suas análises!
			CALL wheb_mensagem_pck.exibir_mensagem_abort(76340);
			end;
		end if;

		end;
	else
		begin
		--Você não participa deste grupo de auditores!
		CALL wheb_mensagem_pck.exibir_mensagem_abort(76342);
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
-- REVOKE ALL ON PROCEDURE pls_assumir_auditoria ( nr_seq_grupo_auditor_p bigint, nr_sequencia_p bigint, nr_seq_ordem_p bigint, nm_usuario_p text) FROM PUBLIC;

