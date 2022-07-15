-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inutiliza_hem_producao_regra ( nr_seq_doacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_pf_realizou_p text, nr_seq_motivo_inutil_p bigint, nr_seq_inutil_p INOUT bigint) AS $body$
DECLARE


nr_seq_inutil_w			san_inutilizacao.nr_sequencia%type;
ie_tipo_bolsa_doacao_w		varchar(5);


BEGIN

if (nr_seq_doacao_p IS NOT NULL AND nr_seq_doacao_p::text <> '') then

	select	max(ie_tipo_bolsa)
	into STRICT	ie_tipo_bolsa_doacao_w
	from	san_doacao
	where	nr_sequencia = nr_seq_doacao_p;

	select 	max(nr_sequencia)
	into STRICT	nr_seq_inutil_w
	from	san_inutilizacao a
	where	a.nr_seq_motivo_inutil = nr_seq_motivo_inutil_p
	and	coalesce(a.dt_fechamento::text, '') = '';

	if (nr_seq_motivo_inutil_p IS NOT NULL AND nr_seq_motivo_inutil_p::text <> '') and (coalesce(nr_seq_inutil_w::text, '') = '') then

		select	nextval('san_inutilizacao_seq')
		into STRICT	nr_seq_inutil_w
		;

		insert into san_inutilizacao( 	nr_sequencia,
						cd_estabelecimento,
						cd_pf_realizou,
						ds_observacao,
						dt_atualizacao,
						dt_atualizacao_nrec,
						dt_fechamento,
						dt_inutilizacao,
						ie_local,
						nm_usuario,
						nm_usuario_fechamento,
						nm_usuario_nrec,
						nr_seq_motivo_inutil  )
				values (	nr_seq_inutil_w,
						cd_estabelecimento_p,
						cd_pf_realizou_p,
						null,
						clock_timestamp(),
						clock_timestamp(),
						null,
						clock_timestamp(),
						null,
						nm_usuario_p,
						null,
						nm_usuario_p,
						nr_seq_motivo_inutil_p);

	end if;

nr_seq_inutil_p		:= nr_seq_inutil_w;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inutiliza_hem_producao_regra ( nr_seq_doacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_pf_realizou_p text, nr_seq_motivo_inutil_p bigint, nr_seq_inutil_p INOUT bigint) FROM PUBLIC;

