-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_fracionamento_automatizado ( nr_seq_doacao_p bigint, nm_usuario_p text, ie_retorno_p INOUT text, ie_retorno2_p INOUT text, ie_retorno3_p INOUT bigint) AS $body$
DECLARE


qt_volume_bolsa_w		bigint;
nr_seq_analis_cri_w		bigint;
nr_seq_regra_w			bigint;
nr_seq_san_regra_deriv_w	bigint;
nr_seq_motivo_inutil_w		bigint;
ie_inutilizar_w			varchar(1);
ie_existe_anals_crit_w		varchar(1);
ie_aux_w			varchar(1);
ie_permite_w			varchar(1);
nr_seq_inutilizacao_w		san_inutilizacao.nr_sequencia%type;


BEGIN
ie_permite_w := '';
nr_seq_motivo_inutil_w := 0;

if (nr_seq_doacao_p IS NOT NULL AND nr_seq_doacao_p::text <> '') then

	select	coalesce(a.qt_volume_real, a.qt_coletada)
	into STRICT	qt_volume_bolsa_w
	from	san_doacao a
	where	a.nr_sequencia = nr_seq_doacao_p;

	--Verifica se a doação ja tem uma Análise Critica cadastrada
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_existe_anals_crit_w
	from	san_prod_analise_critica
	where	nr_seq_doacao	= nr_seq_doacao_p;

	select	max(x.nr_sequencia)
	into STRICT	nr_seq_san_regra_deriv_w
	from	san_regra_volume_frac x
	where	x.ie_situacao = 'A'
	and	qt_volume_bolsa_w between x.qt_volume_min and x.qt_volume_max;

	if (coalesce(nr_seq_san_regra_deriv_w,0) > 0) then

		select	max(x.nr_seq_analise_critica),
			max(coalesce(x.ie_inutilizar,'N')),
			max(CASE WHEN coalesce(x.ie_inutilizar,'N')='S' THEN  x.nr_seq_cad_inut  ELSE 0 END )
		into STRICT	nr_seq_regra_w,
			ie_inutilizar_w,
			nr_seq_motivo_inutil_w
		from	san_regra_volume_frac x
		where	qt_volume_bolsa_w between x.qt_volume_min and x.qt_volume_max
		and	x.nr_sequencia = nr_seq_san_regra_deriv_w;

	end if;

	if (coalesce(nr_seq_regra_w::text, '') = '') then
		ie_aux_w := 'C';
	elsif (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') and ('N' = ie_existe_anals_crit_w) then
		insert into san_prod_analise_critica(
			nr_sequencia,
			dt_analise,
			nr_seq_analise_critica,
			nr_seq_doacao,
			dt_atualizacao,
			nm_usuario
		) values (
			nextval('san_prod_analise_critica_seq'),
			clock_timestamp(),
			nr_seq_regra_w,
			nr_seq_doacao_p,
			clock_timestamp(),
			nm_usuario_p);

		commit;
		ie_aux_w := ie_inutilizar_w;
	end if;

end if;

if (coalesce(nr_seq_motivo_inutil_w,0) > 0) then

	select	max(nr_sequencia)
	into STRICT	nr_seq_inutilizacao_w
	from (
		SELECT	x.nr_sequencia,
			x.dt_inutilizacao
		from	san_inutilizacao x
		where	coalesce(x.dt_fechamento::text, '') = ''
		and	x.nr_seq_motivo_inutil = nr_seq_motivo_inutil_w
		order by dt_inutilizacao desc) alias4 LIMIT 1;

end if;
ie_retorno_p	:= ie_aux_w;
ie_retorno3_p	:= nr_seq_inutilizacao_w;

select	CASE WHEN coalesce(nr_seq_inutilizacao_w::text, '') = '' THEN  'N'  ELSE 'S' END
into STRICT	ie_retorno2_p
;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_fracionamento_automatizado ( nr_seq_doacao_p bigint, nm_usuario_p text, ie_retorno_p INOUT text, ie_retorno2_p INOUT text, ie_retorno3_p INOUT bigint) FROM PUBLIC;

