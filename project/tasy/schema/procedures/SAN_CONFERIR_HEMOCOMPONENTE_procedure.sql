-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_conferir_hemocomponente ( nr_seq_producao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_armazenamento_w	bigint;


BEGIN

update	san_producao
set	dt_conferencia		= clock_timestamp(),
	nm_usuario_conferencia	= nm_usuario_p
where	nr_sequencia		= nr_seq_producao_p;

select	max(a.nr_sequencia)
into STRICT	nr_seq_armazenamento_w
from	san_armazenamento_bolsa a,
	san_armazenamento_regra b,
	san_producao c,
	san_doacao d,
	pessoa_fisica e
where	a.nr_sequencia = b.nr_seq_armazenamento
and	c.nr_seq_doacao = d.nr_sequencia
and	d.cd_pessoa_fisica = e.cd_pessoa_fisica
and	c.nr_sequencia = nr_seq_producao_p
and (b.nr_seq_derivado = c.nr_seq_derivado
or (coalesce(b.nr_seq_derivado::text, '') = ''
and not exists (SELECT	1
		from	san_armazenamento_regra f
		where	f.nr_seq_derivado = c.nr_seq_derivado
		and	f.ie_fator_rh = e.ie_fator_rh
		and	f.ie_tipo_sanguineo = e.ie_tipo_sangue)))
and (b.ie_fator_rh = e.ie_fator_rh
or (coalesce(b.ie_fator_rh::text, '') = ''
and not exists (select	1
		from	san_armazenamento_regra f
		where	f.nr_seq_derivado = c.nr_seq_derivado
		and	f.ie_fator_rh = e.ie_fator_rh
		and	f.ie_tipo_sanguineo = e.ie_tipo_sangue)))
and (b.ie_tipo_sanguineo = e.ie_tipo_sangue
or (coalesce(b.ie_tipo_sanguineo::text, '') = ''
and not exists (select	1
		from	san_armazenamento_regra f
		where	f.nr_seq_derivado = c.nr_seq_derivado
		and	f.ie_fator_rh = e.ie_fator_rh
		and	f.ie_tipo_sanguineo = e.ie_tipo_sangue)))
and	a.ie_tipo_local = 'E';

if (nr_seq_armazenamento_w IS NOT NULL AND nr_seq_armazenamento_w::text <> '') then

	update	san_producao
	set	nm_usuario_ent_estoque = nm_usuario_p,
		dt_entrada_estoque = clock_timestamp(),
		nr_seq_armazenamento = nr_seq_armazenamento_w
	where	nr_sequencia = nr_seq_producao_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_conferir_hemocomponente ( nr_seq_producao_p bigint, nm_usuario_p text) FROM PUBLIC;
