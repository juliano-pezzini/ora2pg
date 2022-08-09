-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fechar_lote_auditoria (nr_seq_lote_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE

/*
ie_acao_p
	'F' - Fechar o lote
	'A' - Reabrir o lote
*/
cont_w			bigint;
ie_param_22_w		varchar(1);
ie_fechar_w		varchar(1) := 'S';
vl_recurso_w		lote_audit_hist.vl_recurso%type;
cd_estab_w		lote_auditoria.cd_estabelecimento%type;


BEGIN

select	cd_estabelecimento
into STRICT	cd_estab_w
from	lote_auditoria
where	nr_sequencia = nr_seq_lote_p;

ie_param_22_w := obter_param_usuario(69, 22, obter_perfil_ativo, nm_usuario_p, cd_estab_w, ie_param_22_w);

if (ie_acao_p = 'F') then

	select	count(*)
	into STRICT	cont_w
	from	lote_audit_hist a
	where	a.nr_seq_lote_audit	= nr_seq_lote_p
	and	coalesce(a.dt_fechamento::text, '') = '';

	if (cont_w > 0) then
		--r.aise_application_error(-20011,'Existem análises em aberto!');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263322);
	end if;

	if (ie_param_22_w = 'A') then

		select 	y.vl_recurso
		into STRICT	vl_recurso_w
		from	lote_audit_hist y
		where	y.nr_sequencia = (
			SELECT 	max(x.nr_sequencia)
			from	lote_audit_hist x
			where	x.nr_seq_lote_audit = nr_seq_lote_p
		);

		if (vl_recurso_w > 0) then
			ie_fechar_w := 'N';
		end if;
	end if;

	if (ie_fechar_w = 'S') then
		update	lote_auditoria
		set	dt_fechamento	= clock_timestamp(),
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_lote_p;
	end if;

elsif (ie_acao_p = 'A') then

	update	lote_auditoria
	set	dt_fechamento	 = NULL,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_lote_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fechar_lote_auditoria (nr_seq_lote_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;
