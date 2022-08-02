-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_incluir_copartic_lote_reaj ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
tx_reajuste_w			pls_lote_reaj_copartic.tx_reajuste%type;
tx_reajuste_vl_maximo_w		pls_lote_reaj_copartic.tx_reajuste_vl_maximo%type;
ie_vinculo_coparticipacao_w	pls_lote_reaj_copartic.ie_vinculo_coparticipacao%type;
nr_seq_reajuste_copartic_w	pls_reajuste_copartic.nr_sequencia%type;
ie_origem_coparticipacao_w	pls_reajuste_copartic.ie_origem_coparticipacao%type;
nr_seq_tipo_copartic_w		pls_tipo_coparticipacao.nr_sequencia%type;
nr_seq_regra_coparticipacao_w	pls_regra_coparticipacao.nr_sequencia%type;
nr_seq_reajuste_w		pls_reajuste.nr_sequencia%type;
nr_seq_lote_reajuste_w		pls_reajuste.nr_sequencia%type;
nr_seq_plano_w			pls_plano.nr_sequencia%type;
nr_seq_regra_copartic_w		pls_regra_copartic.nr_sequencia%type;
nr_seq_intercambio_w		pls_reajuste.nr_seq_intercambio%type;
dt_referencia_w			pls_reajuste.dt_reajuste%type;

C01 CURSOR FOR
	SELECT	x.nr_sequencia,
		x.nr_seq_tipo_coparticipacao,
		'C'
	from	pls_regra_coparticipacao x
	where	((x.nr_seq_contrato	= nr_seq_contrato_w) or (x.nr_seq_intercambio	= nr_seq_intercambio_w))
	and	coalesce(x.ie_reajuste,'S')	= 'S'
	and	((coalesce(x.dt_fim_vigencia::text, '') = '') or (dt_referencia_w <= x.dt_fim_vigencia))
	and	(((nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') and x.nr_seq_plano = nr_seq_plano_w) or (coalesce(nr_seq_plano_w::text, '') = ''))
	
union

	SELECT	q.nr_sequencia,
		q.nr_seq_tipo_coparticipacao,
		'P'
	from	pls_contrato		y,
		pls_contrato_plano	w,
		pls_plano		z,
		pls_regra_coparticipacao q
	where	y.nr_sequencia		= nr_seq_contrato_w
	and	w.nr_seq_contrato	= y.nr_sequencia
	and	w.nr_seq_plano		= z.nr_sequencia
	and	q.nr_seq_plano		= z.nr_sequencia
	and	(((nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') and z.nr_sequencia = nr_seq_plano_w) or (coalesce(nr_seq_plano_w::text, '') = ''))
	and	coalesce(q.nr_seq_contrato::text, '') = ''
	and	coalesce(q.nr_seq_intercambio::text, '') = ''
	and	coalesce(q.nr_seq_proposta::text, '') = ''
	and	((coalesce(q.dt_fim_vigencia::text, '') = '') or (dt_referencia_w <= q.dt_fim_vigencia))
	and	coalesce(q.ie_reajuste,'S')	= 'S'
	and	not exists (	select	1
				from	pls_regra_coparticipacao P
				where	p.nr_seq_contrato	= nr_seq_contrato_w)
	
union

	select 	q.nr_sequencia,
		q.nr_seq_tipo_coparticipacao,
		'P'
        from 	pls_intercambio 	y,
		pls_intercambio_plano 	w,
		pls_plano    		z,
		pls_regra_coparticipacao q
        where 	y.nr_sequencia = nr_seq_intercambio_w
	and  	w.nr_seq_intercambio  	= y.nr_sequencia
	and  	w.nr_seq_plano    	= z.nr_sequencia
	and  	q.nr_seq_plano    	= z.nr_sequencia
	and  	(((nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') and z.nr_sequencia = nr_seq_plano_w) or (coalesce(nr_seq_plano_w::text, '') = ''))
	and	coalesce(q.nr_seq_contrato::text, '') = ''
	and	coalesce(q.nr_seq_intercambio::text, '') = ''
	and	coalesce(q.nr_seq_proposta::text, '') = ''
	and	((coalesce(q.dt_fim_vigencia::text, '') = '') or (dt_referencia_w <= q.dt_fim_vigencia))
	and	coalesce(q.ie_reajuste,'S')	= 'S'
	and	not exists (	select	1
				from	pls_regra_coparticipacao P
				where	p.nr_seq_intercambio	= nr_seq_intercambio_w);

C02 CURSOR FOR
	SELECT	x.nr_sequencia,
		x.nr_seq_tipo_coparticipacao,
		'C'
	from	pls_regra_copartic x
	where	((x.nr_seq_contrato	= nr_seq_contrato_w) or (x.nr_seq_intercambio	= nr_seq_intercambio_w))
	and	((coalesce(x.dt_fim_vigencia::text, '') = '') or (dt_referencia_w <= x.dt_fim_vigencia))
	and	(((nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') and x.nr_seq_plano = nr_seq_plano_w) or (coalesce(nr_seq_plano_w::text, '') = ''))
	
union

	SELECT	q.nr_sequencia,
		q.nr_seq_tipo_coparticipacao,
		'P'
	from	pls_contrato		y,
		pls_contrato_plano	w,
		pls_plano		z,
		pls_regra_copartic	q
	where	y.nr_sequencia		= nr_seq_contrato_w
	and	w.nr_seq_contrato	= y.nr_sequencia
	and	w.nr_seq_plano		= z.nr_sequencia
	and	q.nr_seq_plano		= z.nr_sequencia
	and	(((nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') and z.nr_sequencia = nr_seq_plano_w) or (coalesce(nr_seq_plano_w::text, '') = ''))
	and	((coalesce(q.dt_fim_vigencia::text, '') = '') or (dt_referencia_w <= q.dt_fim_vigencia))
	and	not exists (	select	1
				from	pls_regra_copartic P
				where	p.nr_seq_contrato	= nr_seq_contrato_w)
	
union

	select	q.nr_sequencia,
		q.nr_seq_tipo_coparticipacao,
		'P'
	from	pls_intercambio		y,
		pls_intercambio_plano	w,
		pls_plano		z,
		pls_regra_copartic	q
	where	y.nr_sequencia		= nr_seq_intercambio_w
	and	w.nr_seq_intercambio	= y.nr_sequencia
	and	w.nr_seq_plano		= z.nr_sequencia
	and	q.nr_seq_plano		= z.nr_sequencia
	and	(((nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') and z.nr_sequencia = nr_seq_plano_w) or (coalesce(nr_seq_plano_w::text, '') = ''))
	and	((coalesce(q.dt_fim_vigencia::text, '') = '') or (dt_referencia_w <= q.dt_fim_vigencia))
	and	not exists (	select	1
				from	pls_regra_copartic P
				where	p.nr_seq_intercambio	= nr_seq_intercambio_w);


BEGIN

select	nr_seq_contrato,
	coalesce(tx_reajuste,0),
	coalesce(tx_reajuste_vl_maximo,0),
	coalesce(ie_vinculo_coparticipacao,'A'),
	nr_seq_reajuste,
	nr_seq_intercambio,
	dt_referencia
into STRICT	nr_seq_contrato_w,
	tx_reajuste_w,
	tx_reajuste_vl_maximo_w,
	ie_vinculo_coparticipacao_w,
	nr_seq_reajuste_w,
	nr_seq_intercambio_w,
	dt_referencia_w
from	pls_lote_reaj_copartic
where	nr_sequencia	= nr_seq_lote_p;

if (nr_seq_reajuste_w IS NOT NULL AND nr_seq_reajuste_w::text <> '') then
	select	nr_seq_plano,
		nr_seq_lote_referencia
	into STRICT	nr_seq_plano_w,
		nr_seq_lote_reajuste_w
	from	pls_reajuste
	where	nr_sequencia	= nr_seq_reajuste_w;

	if (nr_seq_lote_reajuste_w IS NOT NULL AND nr_seq_lote_reajuste_w::text <> '') then
		select	nr_seq_plano
		into STRICT	nr_seq_plano_w
		from	pls_reajuste
		where	nr_sequencia	= nr_seq_lote_reajuste_w;
	end if;
end if;

open C01;
loop
fetch C01 into
	nr_seq_regra_coparticipacao_w,
	nr_seq_tipo_copartic_w,
	ie_origem_coparticipacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (ie_vinculo_coparticipacao_w = 'A') or (ie_vinculo_coparticipacao_w = ie_origem_coparticipacao_w) then
		select	nextval('pls_reajuste_copartic_seq')
		into STRICT	nr_seq_reajuste_copartic_w
		;

		insert	into	pls_reajuste_copartic(	nr_sequencia, nr_seq_lote, cd_estabelecimento,
				nr_seq_regra_copartic, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, tx_reajuste,
				tx_valor_maximo, ie_origem_coparticipacao, nr_seq_regra_atual)
			values (nr_seq_reajuste_copartic_w, nr_seq_lote_p, cd_estabelecimento_p,
				nr_seq_tipo_copartic_w, clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p, tx_reajuste_w,
				tx_reajuste_vl_maximo_w, ie_origem_coparticipacao_w, nr_seq_regra_coparticipacao_w);
	end if;
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	nr_seq_regra_copartic_w,
	nr_seq_tipo_copartic_w,
	ie_origem_coparticipacao_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	if (ie_vinculo_coparticipacao_w = 'A') or (ie_vinculo_coparticipacao_w = ie_origem_coparticipacao_w) then
		select	nextval('pls_reajuste_copartic_seq')
		into STRICT	nr_seq_reajuste_copartic_w
		;

		insert	into	pls_reajuste_copartic(	nr_sequencia, nr_seq_lote, cd_estabelecimento,
				nr_seq_regra_copartic, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, tx_reajuste,
				tx_valor_maximo, ie_origem_coparticipacao, nr_seq_copartic_ant)
			values (nr_seq_reajuste_copartic_w, nr_seq_lote_p, cd_estabelecimento_p,
				nr_seq_tipo_copartic_w, clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p, tx_reajuste_w,
				tx_reajuste_vl_maximo_w, ie_origem_coparticipacao_w, nr_seq_regra_copartic_w);
	end if;
	end;
end loop;
close C02;

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_incluir_copartic_lote_reaj ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;

