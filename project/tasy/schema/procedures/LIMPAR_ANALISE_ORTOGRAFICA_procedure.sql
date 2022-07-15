-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_analise_ortografica ( nr_seq_lote_p bigint, dt_referencia_p timestamp, nm_usuario_p text, qt_registro_p INOUT bigint) AS $body$
DECLARE


dt_referencia_w	timestamp;
qt_registro_w	bigint;


BEGIN

dt_referencia_w	:= fim_dia(dt_referencia_p);

if (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') then

	select	count(*)
	into STRICT	qt_registro_w
	from	analise_ortografica_lote a
	where	not exists (SELECT	1
		from	analise_ortografica_lote z,
			analise_ortografica y,
			analise_ortografica x
		where	(z.dt_confirmacao IS NOT NULL AND z.dt_confirmacao::text <> '')
		and	y.nr_seq_lote		= z.nr_sequencia
		and	coalesce(y.ie_diferenca,'N')	= 'S'
		and	x.nr_sequencia		= y.nr_seq_origem
		and	x.nr_seq_lote		= a.nr_sequencia)
	and (coalesce(a.dt_confirmacao::text, '') = '' or
		not exists (select	1
		from	analise_ortografica x
		where	coalesce(x.ie_diferenca,'N')	= 'S'
		and	x.nr_seq_lote	= a.nr_sequencia))
	and	a.dt_atualizacao	<= dt_referencia_w
	and	a.nm_usuario		= nm_usuario_p
	and	a.nr_sequencia		= coalesce(nr_seq_lote_p,a.nr_sequencia);

	/* remover apenas os lotes que não possuem diferença e que não foram confirmados */

	delete	from analise_ortografica_lote a
	where	not exists (SELECT	1
		from	analise_ortografica_lote z,
			analise_ortografica y,
			analise_ortografica x
		where	(z.dt_confirmacao IS NOT NULL AND z.dt_confirmacao::text <> '')
		and	y.nr_seq_lote		= z.nr_sequencia
		and	coalesce(y.ie_diferenca,'N')	= 'S'
		and	x.nr_sequencia		= y.nr_seq_origem
		and	x.nr_seq_lote		= a.nr_sequencia)
	and (coalesce(a.dt_confirmacao::text, '') = '' or
		not exists (select	1
		from	analise_ortografica x
		where	coalesce(x.ie_diferenca,'N')	= 'S'
		and	x.nr_seq_lote	= a.nr_sequencia))
	and	a.dt_atualizacao	<= dt_referencia_w
	and	a.nm_usuario		= nm_usuario_p
	and	a.nr_sequencia		= coalesce(nr_seq_lote_p,a.nr_sequencia);

	delete	from analise_ortografica a
	where	not exists (SELECT	1
		from	analise_ortografica x
		where	coalesce(x.ie_diferenca,'N')	= 'S'
		and	x.nr_seq_origem	= a.nr_sequencia)
	and	coalesce(a.ie_diferenca,'N')	= 'N'
	and	a.dt_atualizacao	<= dt_referencia_w
	and	a.nm_usuario		= nm_usuario_p
	and	a.nr_seq_lote		= coalesce(nr_seq_lote_p,a.nr_seq_lote);

end if;

qt_registro_p	:= coalesce(qt_registro_w,0);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_analise_ortografica ( nr_seq_lote_p bigint, dt_referencia_p timestamp, nm_usuario_p text, qt_registro_p INOUT bigint) FROM PUBLIC;

