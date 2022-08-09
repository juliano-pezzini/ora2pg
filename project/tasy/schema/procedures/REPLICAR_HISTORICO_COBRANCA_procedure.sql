-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE replicar_historico_cobranca ( nr_seq_historico_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_cobranca_w	bigint;
ie_status_w		varchar(1);
cd_pessoa_fisica_w	varchar(10);
cd_cgc_w		varchar(14);
ie_replicar_historico_w	varchar(1)	:= 'N';
nr_sequencia_w		bigint;
nr_titulo_w		bigint;
nr_seq_cheque_w		bigint;
ie_etapa_cob_w		varchar(1);
cd_estabelecimento_w	smallint;
nr_seq_etapa_w		bigint;

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	titulo_receber b,
	cobranca a
where	a.nr_titulo		= b.nr_titulo
and	b.cd_pessoa_fisica	= cd_pessoa_fisica_w
and	a.ie_status		= 'P'
and	a.nr_sequencia		<> nr_seq_cobranca_w
and (coalesce(ie_etapa_cob_w,'N') = 'N' or a.nr_seq_etapa = nr_seq_etapa_w)

union all

select	a.nr_sequencia
from	titulo_receber b,
	cobranca a
where	a.nr_titulo		= b.nr_titulo
and	b.cd_cgc		= cd_cgc_w
and	a.ie_status		= 'P'
and	a.nr_sequencia		<> nr_seq_cobranca_w
and (coalesce(ie_etapa_cob_w,'N') = 'N' or a.nr_seq_etapa = nr_seq_etapa_w)

union all

select	a.nr_sequencia
from	cheque_cr b,
	cobranca a
where	a.nr_seq_cheque		= b.nr_seq_cheque
and	b.cd_pessoa_fisica	= cd_pessoa_fisica_w
and	a.ie_status		= 'P'
and	a.nr_sequencia		<> nr_seq_cobranca_w
and (coalesce(ie_etapa_cob_w,'N') = 'N' or a.nr_seq_etapa = nr_seq_etapa_w)

union all

select	a.nr_sequencia
from	cheque_cr b,
	cobranca a
where	a.nr_seq_cheque		= b.nr_seq_cheque
and	b.cd_cgc		= cd_cgc_w
and	a.ie_status		= 'P'
and	a.nr_sequencia		<> nr_seq_cobranca_w
and (coalesce(ie_etapa_cob_w,'N') = 'N' or a.nr_seq_etapa = nr_seq_etapa_w);


BEGIN

if (nr_seq_historico_p IS NOT NULL AND nr_seq_historico_p::text <> '') then

	select	max(a.nr_seq_cobranca),
		coalesce(max(b.ie_replicar_historico),'N'),
		max(c.cd_estabelecimento),
		max(c.nr_seq_etapa)
	into STRICT	nr_seq_cobranca_w,
		ie_replicar_historico_w,
		cd_estabelecimento_w,
		nr_seq_etapa_w
	from	cobranca c,
		tipo_hist_cob b,
		cobranca_historico a
	where	a.nr_seq_historico	= b.nr_sequencia
	and	a.nr_sequencia		= nr_seq_historico_p
	and	a.nr_seq_cobranca	= c.nr_sequencia;

	if (ie_replicar_historico_w = 'S') then

		ie_etapa_cob_w := obter_param_usuario(860, 17, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_etapa_cob_w);

		select	nr_titulo,
			nr_seq_cheque
		into STRICT	nr_titulo_w,
			nr_seq_cheque_w
		from	cobranca
		where	nr_sequencia	= nr_seq_cobranca_w;

		if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
			select	cd_pessoa_fisica,
				cd_cgc
			into STRICT	cd_pessoa_fisica_w,
				cd_cgc_w
			from	titulo_receber
			where	nr_titulo	= nr_titulo_w;
		elsif (nr_seq_cheque_w IS NOT NULL AND nr_seq_cheque_w::text <> '') then
			select	cd_pessoa_fisica,
				cd_cgc
			into STRICT	cd_pessoa_fisica_w,
				cd_cgc_w
			from	cheque_cr
			where	nr_seq_cheque	= nr_seq_cheque_w;
		end if;

		open c01;
		loop
		fetch c01 into
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */

			insert	into	cobranca_historico(nr_sequencia,
				nr_seq_cobranca,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_historico,
				ds_historico,
				dt_historico,
				vl_historico)
			SELECT	nextval('cobranca_historico_seq'),
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_historico,
				ds_historico,
				dt_historico,
				vl_historico
			from	cobranca_historico
			where	nr_sequencia	= nr_seq_historico_p;

		end loop;
		close c01;
	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE replicar_historico_cobranca ( nr_seq_historico_p bigint, nm_usuario_p text) FROM PUBLIC;
