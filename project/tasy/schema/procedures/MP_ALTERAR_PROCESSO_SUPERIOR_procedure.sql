-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mp_alterar_processo_superior ( nr_seq_objeto_p bigint, nr_seq_processo_novo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_tipo_grupo_w		varchar(10);
qt_contrario_w		bigint;


BEGIN

if (nr_seq_objeto_p IS NOT NULL AND nr_seq_objeto_p::text <> '') and (nr_seq_processo_novo_p IS NOT NULL AND nr_seq_processo_novo_p::text <> '') then

	select	max(c.ie_tipo_grupo)
	into STRICT	ie_tipo_grupo_w
	from	mp_grupo_objeto		c,
		mp_objeto		b,
		mp_processo_objeto	a
	where	a.nr_seq_objeto	= b.nr_sequencia
	and	b.nr_seq_grupo	= c.nr_sequencia
	and	a.nr_sequencia	= nr_seq_objeto_p;

	if (ie_tipo_grupo_w = 'P') then
		select	count(*)
		into STRICT	qt_contrario_w
		from	mp_processo_objeto a
		where	a.nr_seq_processo	= nr_seq_processo_novo_p
		and	not exists (SELECT	1
					from	mp_processo x
					where	x.nr_sequencia	= a.nr_seq_processo_ref);
		if (qt_contrario_w > 0) then
			-- Este processo já possui atividades, não é permitido incluir este tipo de objeto.
			CALL wheb_mensagem_pck.exibir_mensagem_abort(267038);
		end if;
	else
		select	count(*)
		into STRICT	qt_contrario_w
		from	mp_processo_objeto a
		where	a.nr_seq_processo	= nr_seq_processo_novo_p
		and	exists (SELECT	1
				from	mp_processo x
				where	x.nr_seq_objeto	= a.nr_seq_objeto);

		if (qt_contrario_w > 0) then
			-- Este processo já possui sub-processos, não é permitido incluir processos filhos.
			CALL wheb_mensagem_pck.exibir_mensagem_abort(267039);
		end if;
	end if;

	update	mp_processo a
	set	nr_seq_superior	= nr_seq_processo_novo_p
	where	exists (SELECT	1
			from	mp_processo_objeto x
			where	x.nr_seq_processo_ref = a.nr_sequencia
			and	x.nr_sequencia	= nr_seq_objeto_p);

	update	mp_processo_objeto
	set	nr_seq_processo	= nr_seq_processo_novo_p
	where	nr_sequencia	= nr_seq_objeto_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mp_alterar_processo_superior ( nr_seq_objeto_p bigint, nr_seq_processo_novo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
