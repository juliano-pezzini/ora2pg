-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajuste_inicio_prospect (nm_usuario_p text) AS $body$
DECLARE


nr_seq_cliente_w	bigint;
dt_inicio_prospect_w	timestamp;
nr_seq_canal_w		bigint;
qt_prospect_w		bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	com_cliente a
	where	a.ie_classificacao	= 'P'
	and	not exists (	SELECT	1
				from	com_cliente_log x
				where	a.nr_sequencia	= x.nr_seq_cliente
				and	x.ie_log	= 2
				and	x.ie_classificacao = 'P');


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_cliente_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	count(*)
	into STRICT	qt_prospect_w
	from	com_canal_cliente
	where	nr_seq_cliente = nr_seq_cliente_w
	and	ie_tipo_atuacao = 'V'
	and	coalesce(dt_fim_atuacao::text, '') = '';

	if (qt_prospect_w <> 0) then
		select	max(dt_inicio_atuacao),
			max(nr_seq_canal)
		into STRICT	dt_inicio_prospect_w,
			nr_seq_canal_w
		from	com_canal_cliente
		where	nr_seq_cliente = nr_seq_cliente_w
		and	ie_tipo_atuacao = 'V'
		and	coalesce(dt_fim_atuacao::text, '') = '';


		insert into com_cliente_log(	NR_SEQUENCIA,
						NR_SEQ_CLIENTE,
						DT_ATUALIZACAO,
						NM_USUARIO,
						DT_ATUALIZACAO_NREC,
						NM_USUARIO_NREC,
						IE_LOG,
						DT_LOG,
						IE_CLASSIFICACAO,
						IE_FASE_VENDA,
						NR_SEQ_CANAL)
					values (	nextval('com_cliente_log_seq'),
						nr_seq_cliente_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						2,
						dt_inicio_prospect_w,
						'P',
						null,
						null);

		insert into com_cliente_log(	NR_SEQUENCIA,
						NR_SEQ_CLIENTE,
						DT_ATUALIZACAO,
						NM_USUARIO,
						DT_ATUALIZACAO_NREC,
						NM_USUARIO_NREC,
						IE_LOG,
						DT_LOG,
						IE_CLASSIFICACAO,
						IE_FASE_VENDA,
						NR_SEQ_CANAL)
					values (	nextval('com_cliente_log_seq'),
						nr_seq_cliente_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						3,
						dt_inicio_prospect_w,
						null,
						null,
						nr_seq_canal_w);
	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajuste_inicio_prospect (nm_usuario_p text) FROM PUBLIC;

